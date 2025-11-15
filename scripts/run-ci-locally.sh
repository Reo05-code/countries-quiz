#!/bin/bash

# CI チェックをローカルで実行するスクリプト

set -e

echo "======================================"
echo "🚀 Running Local CI Checks"
echo "======================================"
echo ""

# 引数から対象を取得（backend, frontend, all）
TARGET="${1:-all}"

run_backend_ci() {
  echo "📦 Backend CI Checks"
  echo "--------------------------------------"

  echo "⚙️  1. Running RSpec tests..."
  docker-compose exec -T backend rspec
  echo "✅ RSpec tests passed"
  echo ""

  echo "⚙️  2. Running RuboCop..."
  docker-compose exec -T backend rubocop
  echo "✅ RuboCop passed"
  echo ""

  echo "⚙️  3. Running security audit..."
  docker-compose exec -T backend bash -c "gem install bundler-audit --quiet && bundler-audit check --update"
  echo "✅ Security audit passed"
  echo ""
}

run_frontend_ci() {
  echo "🎨 Frontend CI Checks"
  echo "--------------------------------------"

  echo "⚙️  1. Running ESLint..."
  docker-compose exec -T frontend npm run lint
  echo "✅ ESLint passed"
  echo ""

  echo "⚙️  2. Running TypeScript check..."
  docker-compose exec -T frontend npm run type-check
  echo "✅ TypeScript check passed"
  echo ""

  echo "⚙️  3. Running build check..."
  docker-compose exec -T frontend npm run build
  echo "✅ Build check passed"
  echo ""

  echo "⚙️  4. Running security audit..."
  docker-compose exec -T frontend npm audit --audit-level=moderate || echo "⚠️  Security warnings found (non-blocking)"
  echo ""
}

run_integration_tests() {
  echo "🔗 Integration Tests"
  echo "--------------------------------------"

  echo "⚙️  1. Testing backend health..."
  curl -f http://localhost:3001/health > /dev/null 2>&1
  echo "✅ Backend is healthy"
  echo ""

  echo "⚙️  2. Testing frontend..."
  curl -f http://localhost:3000 > /dev/null 2>&1
  echo "✅ Frontend is accessible"
  echo ""
}

# コンテナが起動しているか確認
if ! docker-compose ps | grep -q "Up"; then
  echo "⚠️  Containers are not running. Starting..."
  docker-compose up -d
  echo "Waiting for services to be ready..."
  sleep 10
fi

case $TARGET in
  backend)
    run_backend_ci
    ;;
  frontend)
    run_frontend_ci
    ;;
  integration)
    run_integration_tests
    ;;
  all)
    run_backend_ci
    run_frontend_ci
    run_integration_tests
    ;;
  *)
    echo "Usage: $0 {backend|frontend|integration|all}"
    exit 1
    ;;
esac

echo "======================================"
echo "✅ All CI checks passed!"
echo "======================================"
echo ""
echo "💡 Your code is ready to be pushed!"
