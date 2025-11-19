import camelcaseKeys from 'camelcase-keys'
import { apiClient } from './client'
import type { QuizQuestion, QuizCheckRequest, QuizCheckResponse } from '@/types/quiz'

/**
 * ランダムな国クイズ問題を取得
 */
export async function fetchRandomQuiz(): Promise<QuizQuestion> {
  const response = await apiClient.get('/api/v1/countries/random')

  // snake_case → camelCase 変換
  return camelcaseKeys(response.data, { deep: true })
}

/**
 * クイズの回答をチェック
 */
export async function checkAnswer(quizId: number, answer: string): Promise<QuizCheckResponse> {
  const requestBody: QuizCheckRequest = {
    quizId,
    answer,
  }

  // リクエストは snake_case に変換する必要があるが、
  // 現状のバックエンドは params[:quiz_id] と params[:answer] を受け取る。
  // axios はデフォルトで JSON をそのまま送る。
  // camelcase-keys はレスポンス変換用。
  // リクエストのキーを snake_case に変換するか、手動でマッピングする。
  // ここでは手動でマッピングして送信する。

  const response = await apiClient.post('/api/v1/quizzes/check', {
    quiz_id: quizId,
    answer: answer,
  })

  return camelcaseKeys(response.data, { deep: true })
}
