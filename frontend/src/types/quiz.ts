// クイズ問題データの型定義
export interface QuizQuestion {
  quiz_id: number
  flag_url: string
  hints: string[]
}

// クイズ回答チェックのリクエスト型
export interface QuizCheckRequest {
  quiz_id: number
  answer: string
}

// クイズ回答チェックのレスポンス型
export interface QuizCheckResponse {
  correct: boolean
  correct_answer: string
}

// エラーレスポンスの型
export interface ApiErrorResponse {
  error: string
}
