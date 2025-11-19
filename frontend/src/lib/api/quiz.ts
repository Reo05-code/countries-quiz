import camelcaseKeys from 'camelcase-keys'
import { apiClient } from './client'
import type { QuizQuestion } from '@/types/quiz'

/**
 * ランダムな国クイズ問題を取得
 */
export async function fetchRandomQuiz(): Promise<QuizQuestion> {
  const response = await apiClient.get('/countries/random')

  // snake_case → camelCase 変換
  return camelcaseKeys(response.data, { deep: true })
}
