'use client'

import { useState } from 'react'
import { fetchRandomQuiz, checkAnswer } from '@/lib/api/quiz'
import type { QuizQuestion, QuizCheckResponse } from '@/types/quiz'

export default function QuizPage() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [quiz, setQuiz] = useState<QuizQuestion | null>(null)
  const [answer, setAnswer] = useState('')
  const [result, setResult] = useState<QuizCheckResponse | null>(null)

  const handleStartQuiz = async () => {
    setLoading(true)
    setError(null)
    setQuiz(null)
    setResult(null)
    setAnswer('')

    try {
      console.log('🎮 クイズデータを取得中...')
      const data = await fetchRandomQuiz()
      console.log('✅ 取得成功:', data)
      setQuiz(data)
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'データ取得に失敗しました'
      console.error('❌ エラー:', errorMessage)
      setError(errorMessage)
    } finally {
      setLoading(false)
    }
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!quiz || !answer.trim()) return

    setLoading(true)
    setError(null)

    try {
      console.log('🤔 回答を送信中:', answer)
      const data = await checkAnswer(quiz.quizId, answer)
      console.log('📝 結果:', data)
      setResult(data)
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : '回答の送信に失敗しました'
      console.error('❌ エラー:', errorMessage)
      setError(errorMessage)
    } finally {
      setLoading(false)
    }
  }

  return (
    <main className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100 p-4">
      <div className="max-w-2xl w-full">
        <div className="bg-white rounded-2xl shadow-xl p-8">
          {/* タイトル */}
          <div className="text-center mb-8">
            <h1 className="text-4xl font-bold text-gray-800 mb-2">
              🌍 国旗クイズ
            </h1>
            <p className="text-gray-600">
              国旗を見て国名を当てよう！
            </p>
          </div>

          {/* クイズ表示エリア */}
          {quiz ? (
            <div className="mb-8 text-center">
              <div className="relative w-64 h-40 mx-auto mb-6 shadow-lg rounded-lg overflow-hidden border border-gray-200">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img
                  src={quiz.flagUrl}
                  alt="国旗"
                  className="w-full h-full object-cover"
                />
              </div>
              <p className="text-gray-500 text-sm mb-4">
                この国旗の国名は？
              </p>

              {/* 回答フォーム */}
              {!result ? (
                <form onSubmit={handleSubmit} className="max-w-xs mx-auto">
                  <input
                    type="text"
                    value={answer}
                    onChange={(e) => setAnswer(e.target.value)}
                    placeholder="国名を入力（ひらがな・カタカナ）"
                    className="w-full px-4 py-2 mb-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                    disabled={loading}
                  />
                  <button
                    type="submit"
                    disabled={loading || !answer.trim()}
                    className="w-full bg-green-600 hover:bg-green-700 disabled:bg-gray-400 text-white font-bold py-2 px-4 rounded-lg shadow transition disabled:cursor-not-allowed"
                  >
                    {loading ? '確認中...' : '回答する'}
                  </button>
                </form>
              ) : (
                /* 結果表示 */
                <div className="mt-6 animate-fade-in">
                  {result.correct ? (
                    <div className="text-green-600 mb-4">
                      <p className="text-5xl mb-2">⭕</p>
                      <p className="text-xl font-bold">正解！</p>
                    </div>
                  ) : (
                    <div className="text-red-600 mb-4">
                      <p className="text-5xl mb-2">❌</p>
                      <p className="text-xl font-bold">残念...</p>
                    </div>
                  )}
                  <p className="text-gray-700 mb-6">
                    正解は <span className="font-bold text-lg">{result.correctAnswer}</span> でした
                  </p>
                  <button
                    onClick={handleStartQuiz}
                    className="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-6 rounded-lg shadow transition"
                  >
                    次の問題へ
                  </button>
                </div>
              )}
            </div>
          ) : (
            /* 開始ボタン */
            <div className="text-center">
              <button
                onClick={handleStartQuiz}
                disabled={loading}
                className="bg-blue-600 hover:bg-blue-700 disabled:bg-gray-400 text-white font-bold py-4 px-8 rounded-lg text-xl shadow-lg transition disabled:cursor-not-allowed"
              >
                {loading ? '読み込み中...' : 'クイズを開始'}
              </button>
            </div>
          )}

          {/* エラー表示 */}
          {error && (
            <div className="mt-4 p-4 bg-red-50 border border-red-200 rounded-lg">
              <p className="text-red-800 text-sm">{error}</p>
            </div>
          )}
        </div>
      </div>
    </main>
  )
}
