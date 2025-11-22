// クイズ問題データの型定義
export interface QuizQuestion {
  quizId: number
  hints: string[]
  characterChoices: string[]
}

// クイズ回答チェックのリクエスト型
export interface QuizCheckRequest {
  quizId: number
  answer: string
}

// クイズ回答チェックのレスポンス型
export interface QuizCheckResponse {
  correct: boolean
  correctAnswer: string
  flagUrl?: string
}

// エラーレスポンスの型
export interface ApiErrorResponse {
  error: string
}
