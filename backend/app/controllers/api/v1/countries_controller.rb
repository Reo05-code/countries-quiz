# app/controllers/api/v1/countries_controller.rb
module Api
  module V1
    # 改善1: ActionController::API を継承
    class CountriesController < ActionController::API
      # ひらがなの全リスト（濁点・半濁点含む）
      HIRAGANA = "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽゃゅょっぁぃぅぇぉ".chars.freeze

      def random
        # 改善2: もし国が0件だった場合のnilを考慮
        country = Country.order("RANDOM()").first

        if country
          # 正解の国名をひらがなに変換し、文字の配列にする
          correct_chars = normalize_to_hiragana(country.reading).chars.uniq

          # ダミー文字を生成
          # 1. 全ひらがなから正解の文字を除く
          hiragana_without_correct = HIRAGANA - correct_chars
          # 2. 選択肢が合計12文字になるようにダミー文字をサンプリング
          num_dummy_chars = [12 - correct_chars.length, 0].max # 念のためマイナスにならないように
          dummy_chars = hiragana_without_correct.sample(num_dummy_chars)

          # 正解文字とダミー文字を結合してシャッフル
          character_choices = (correct_chars + dummy_chars).shuffle

          render json: {
            quiz_id: country.id,
            hints: [country.hint_1, country.hint_2, country.hint_3, country.hint_4].compact,
            character_choices: character_choices
          }, status: :ok
        else
          # データベースが空の場合のエラーハンドリング
          render json: { error: "No countries available." }, status: :not_found
        end
      end

      private

      def normalize_to_hiragana(text)
        # 前後の空白を削除してカタカナをひらがなに変換
        text.to_s.strip.tr("ァ-ヴ", "ぁ-ゔ")
      end
    end
  end
end
