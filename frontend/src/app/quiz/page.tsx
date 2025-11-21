'use client'

import { useState, useEffect, useRef } from 'react'
import { fetchRandomQuiz, checkAnswer } from '@/lib/api/quiz'
import type { QuizQuestion, QuizCheckResponse } from '@/types/quiz'

// 文字選択肢の型定義
type CharacterChoice = {
  char: string
  id: number // 元の配列でのインデックスを保持
}

// 回答として選択された文字の型定義
type AnswerChar = {
  char: string
  choiceId: number // どの選択肢から来たかを保持
}

export default function QuizPage() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [quiz, setQuiz] = useState<QuizQuestion | null>(null)
  const [result, setResult] = useState<QuizCheckResponse | null>(null)

  // パズル用のstate
  const [answerChars, setAnswerChars] = useState<AnswerChar[]>([])
  const [choices, setChoices] = useState<CharacterChoice[]>([])

  // ヒント表示用のstate
  const [displayedHints, setDisplayedHints] = useState<string[]>([])
  const hintFourTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)

  const clearHintFourTimer = () => {
    if (hintFourTimerRef.current) {
      clearTimeout(hintFourTimerRef.current)
      hintFourTimerRef.current = null
    }
  }

  // クイズ開始処理
  const handleStartQuiz = async () => {
    clearHintFourTimer()
    setLoading(true)
    setError(null)
    setQuiz(null)
    setResult(null)
    setAnswerChars([])
    setChoices([])
    setDisplayedHints([])

    try {
      console.log('🎮 クイズデータを取得中...')
      const data = await fetchRandomQuiz()
      console.log('✅ 取得成功:', data)
      setQuiz(data)
      // 選択肢をstateにセット（idを付与）
      setChoices(data.characterChoices.map((char, index) => ({ char, id: index })))
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'データ取得に失敗しました'
      console.error('❌ エラー:', errorMessage)
      setError(errorMessage)
    } finally {
      setLoading(false)
    }
  }

  // ヒントを段階的に表示するエフェクト
  useEffect(() => {
    if (!quiz) return

    // 既存のタイマーをクリア
    const timers = Array.from({ length: quiz.hints.length }, (_, i) =>
      setTimeout(() => {
        setDisplayedHints(prev => [...prev, quiz.hints[i]])
      }, (i + 1) * 2000)
    );

    // コンポーネントのクリーンアップ
    return () => {
      timers.forEach(clearTimeout)
    }
  }, [quiz])

  // ヒント4の表示から5秒後に自動的に失敗する
  useEffect(() => {
    if (!quiz || result || displayedHints.length < 4) return
    if (hintFourTimerRef.current) return

    hintFourTimerRef.current = setTimeout(async () => {
      hintFourTimerRef.current = null
      if (!quiz || result) return

      setLoading(true)
      try {
        const data = await checkAnswer(quiz.quizId, '')
        setResult(data)
        setError('ヒント4から5秒以内に回答がなかったためタイムアウトしました。')
      } catch (err) {
        const errorMessage = err instanceof Error ? err.message : 'タイムアウト結果の取得に失敗しました'
        setError(errorMessage)
      } finally {
        setLoading(false)
      }
    }, 5000)
  }, [displayedHints.length, quiz, result])

  useEffect(() => {
    if (result) {
      clearHintFourTimer()
    }
  }, [result])

  useEffect(() => {
    return () => {
      clearHintFourTimer()
    }
  }, [])


  // 文字を選択肢から回答へ移動
  const handleSelectChoice = (choice: CharacterChoice) => {
    setAnswerChars(prev => [...prev, { char: choice.char, choiceId: choice.id }])
    setChoices(prev => prev.filter(c => c.id !== choice.id))
  }

  // 文字を回答から選択肢へ戻す
  const handleRemoveFromAnswer = (answerChar: AnswerChar, index: number) => {
    setAnswerChars(prev => prev.filter((_, i) => i !== index))
    const originalChoice = quiz?.characterChoices[answerChar.choiceId]
    if (originalChoice) {
      setChoices(prev => [...prev, { char: originalChoice, id: answerChar.choiceId }].sort((a, b) => a.id - b.id))
    }
  }

  // 回答を送信
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!quiz || answerChars.length === 0) return

    setLoading(true)
    setError(null)
    const finalAnswer = answerChars.map(ac => ac.char).join('')

    try {
      console.log('🤔 回答を送信中:', finalAnswer)
      const data = await checkAnswer(quiz.quizId, finalAnswer)
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
    <main className="min-h-screen flex items-center justify-center bg-gradient-to-br from-gray-100 to-gray-200 p-4">
      <div className="max-w-3xl w-full">
        <div className="bg-white rounded-2xl shadow-xl p-8">
          {/* タイトル */}
          <div className="text-center mb-8">
            <h1 className="text-4xl font-bold text-gray-800 mb-2">
              🌍 国名クイズ
            </h1>
            <p className="text-gray-600">
              ヒントから国名を当てよう！
            </p>
          </div>

          {/* クイズ表示エリア */}
          {quiz ? (
            <div className="text-center">
              {/* ヒント表示 */}
              <div className="h-32 mb-6 p-4 bg-gray-50 rounded-lg border border-gray-200 flex flex-col justify-center items-center">
                {displayedHints.length > 0 ? (
                  displayedHints.map((hint, index) => (
                    <p key={index} className="text-gray-700 text-lg mb-1 animate-fade-in">
                      ヒント{index + 1}: {hint}
                    </p>
                  ))
                ) : (
                  <p className="text-gray-500">ヒントを待っています...</p>
                )}
              </div>

              {/* 結果表示 or パズルエリア */}
              {!result ? (
                <form onSubmit={handleSubmit}>
                  {/* 回答欄 */}
                  <div className="h-20 mb-6 bg-gray-100 rounded-lg flex items-center justify-center p-2 border-2 border-dashed">
                    {answerChars.length > 0 ? (
                      answerChars.map((ac, index) => (
                        <button
                          key={index}
                          type="button"
                          onClick={() => handleRemoveFromAnswer(ac, index)}
                          className="h-12 w-12 m-1 bg-blue-500 text-white text-2xl font-bold rounded-lg flex items-center justify-center shadow-md"
                        >
                          {ac.char}
                        </button>
                      ))
                    ) : (
                      <p className="text-gray-400">下の文字を選択して国名を完成させよう</p>
                    )}
                  </div>

                  {/* 文字選択肢 */}
                  <div className="mb-6 grid grid-cols-6 gap-2">
                    {choices.map((choice) => (
                      <button
                        key={choice.id}
                        type="button"
                        onClick={() => handleSelectChoice(choice)}
                        className="h-14 w-14 bg-white border-2 border-gray-300 text-gray-700 text-2xl font-bold rounded-lg flex items-center justify-center shadow-sm hover:bg-gray-100 transition"
                      >
                        {choice.char}
                      </button>
                    ))}
                  </div>

                  <button
                    type="submit"
                    disabled={loading || answerChars.length === 0}
                    className="w-full bg-green-600 hover:bg-green-700 disabled:bg-gray-400 text-white font-bold py-3 px-4 rounded-lg shadow-lg transition disabled:cursor-not-allowed"
                  >
                    {loading ? '確認中...' : '回答する'}
                  </button>
                </form>
              ) : (
                /* 結果表示 */
                <div className="mt-6 animate-fade-in">
                  {result.correct ? (
                    <div className="text-green-600 mb-4">
                      <p className="text-6xl mb-2">⭕</p>
                      <p className="text-2xl font-bold">正解！</p>
                    </div>
                  ) : (
                    <div className="text-red-600 mb-4">
                      <p className="text-6xl mb-2">❌</p>
                      <p className="text-2xl font-bold">残念...</p>
                    </div>
                  )}
                  <p className="text-gray-700 mb-6">
                    正解は <span className="font-bold text-2xl">{result.correctAnswer}</span> でした
                  </p>
                  <button
                    onClick={handleStartQuiz}
                    className="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-6 rounded-lg shadow-lg transition"
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
