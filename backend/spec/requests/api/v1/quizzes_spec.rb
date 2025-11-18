require "rails_helper"

RSpec.describe "Api::V1::Quizzes" do
  describe "POST /api/v1/quizzes/check" do
    let!(:country) do
      Country.create!(
        name: "日本",
        reading: "にほん",
        hint_1: "世界で62位の面積",
        hint_2: "通貨: 円 (JPY)",
        hint_3: "首都: 東京",
        hint_4: "寿司とアニメで有名",
        flag_url: "https://flagcdn.com/w320/jp.png"
      )
    end

    context "正しい答えの場合" do
      it "ひらがなで正解を返す" do
        post "/api/v1/quizzes/check", params: {
          quiz_id: country.id,
          answer: "にほん"
        }

        expect(response).to have_http_status(:ok)

        json = response.parsed_body
        expect(json["correct"]).to be true
        expect(json["correct_answer"]).to eq("日本")
      end

      it "カタカナで正解を返す" do
        post "/api/v1/quizzes/check", params: {
          quiz_id: country.id,
          answer: "ニホン"
        }

        expect(response).to have_http_status(:ok)

        json = response.parsed_body
        expect(json["correct"]).to be true
        expect(json["correct_answer"]).to eq("日本")
      end

      it "前後の空白を無視する" do
        post "/api/v1/quizzes/check", params: {
          quiz_id: country.id,
          answer: "  にほん  "
        }

        expect(response).to have_http_status(:ok)

        json = response.parsed_body
        expect(json["correct"]).to be true
        expect(json["correct_answer"]).to eq("日本")
      end
    end

    context "間違った答えの場合" do
      it "ひらがなで不正解を返す" do
        post "/api/v1/quizzes/check", params: {
          quiz_id: country.id,
          answer: "ちゅうごく"
        }

        expect(response).to have_http_status(:ok)

        json = response.parsed_body
        expect(json["correct"]).to be false
        expect(json["correct_answer"]).to eq("日本")
      end
    end

    context "無効なquiz_idの場合" do
      it "エラーメッセージを返す" do
        post "/api/v1/quizzes/check", params: {
          quiz_id: 99999,
          answer: "日本"
        }

        expect(response).to have_http_status(:bad_request)

        json = response.parsed_body
        expect(json["error"]).to eq("Invalid quiz_id")
      end
    end

    context "quiz_idパラメータが存在しない場合" do
      it "エラーメッセージを返す" do
        post "/api/v1/quizzes/check", params: {
          answer: "日本"
        }

        expect(response).to have_http_status(:bad_request)

        json = response.parsed_body
        expect(json["error"]).to eq("Invalid quiz_id")
      end
    end

    context "answerパラメータが存在しない場合" do
      it "不正解を返す" do
        post "/api/v1/quizzes/check", params: {
          quiz_id: country.id
        }

        expect(response).to have_http_status(:ok)

        json = response.parsed_body
        expect(json["correct"]).to be false
        expect(json["correct_answer"]).to eq("日本")
      end
    end

    context "複数の国が存在する場合" do
      let!(:germany) do
        Country.create!(
          name: "ドイツ",
          reading: "どいつ",
          hint_1: "世界で63位の面積",
          hint_2: "通貨: ユーロ (EUR)",
          hint_3: "首都: ベルリン",
          hint_4: "ビールとソーセージ",
          flag_url: "https://flagcdn.com/w320/de.png"
        )
      end

      it "ひらがなで正しく判定する" do
        post "/api/v1/quizzes/check", params: {
          quiz_id: germany.id,
          answer: "どいつ"
        }

        expect(response).to have_http_status(:ok)

        json = response.parsed_body
        expect(json["correct"]).to be true
        expect(json["correct_answer"]).to eq("ドイツ")
      end

      it "カタカナで正しく判定する" do
        post "/api/v1/quizzes/check", params: {
          quiz_id: germany.id,
          answer: "ドイツ"
        }

        expect(response).to have_http_status(:ok)

        json = response.parsed_body
        expect(json["correct"]).to be true
        expect(json["correct_answer"]).to eq("ドイツ")
      end

      it "異なる国の名前では不正解になる" do
        post "/api/v1/quizzes/check", params: {
          quiz_id: germany.id,
          answer: "にほん"
        }

        expect(response).to have_http_status(:ok)

        json = response.parsed_body
        expect(json["correct"]).to be false
        expect(json["correct_answer"]).to eq("ドイツ")
      end
    end
  end
end
