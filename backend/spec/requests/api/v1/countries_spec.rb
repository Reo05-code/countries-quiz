require "rails_helper"

RSpec.describe "Api::V1::Countries" do
  describe "GET /api/v1/countries/random" do
    # RSpec/ContextWording: context は "when/with/without" で始める
    context "when multiple countries exist" do
      # 複数のデータを作成して「ランダム性」をテストできるようにする
      let!(:country_a) do
        Country.create!(name: "日本",
                        reading: "にほん",
                        flag_url: "jp.png",
                        hint_1: "ヒントA1",
                        hint_2: "ヒントA2",
                        hint_3: "ヒントA3",
                        hint_4: "ヒントA4")
      end

      let!(:country_b) do
        Country.create!(name: "フランス",
                        reading: "ふらんす",
                        flag_url: "fr.png",
                        hint_1: "ヒントB1",
                        hint_2: "ヒントB2",
                        hint_3: "ヒントB3",
                        hint_4: "ヒントB4")
      end

      # 検証に使う「存在するIDのリスト」を用意
      let(:country_ids) { [country_a.id, country_b.id] }
      let(:returned_country) { Country.find(json["quiz_id"]) }

      # RSpec/ExampleLength と RSpec/MultipleExpectations: テストを分割
      it "returns 200 OK status" do
        get "/api/v1/countries/random"
        expect(response).to have_http_status(:ok)
      end

      it "既存の国IDのいずれかを返す" do
        get "/api/v1/countries/random"
        json = response.parsed_body
        expect(Country.exists?(json["quiz_id"])).to be true
      end

      it "必要なキーを含む正しいJSON構造を返す" do
        get "/api/v1/countries/random"
        json = response.parsed_body
        expect(json.keys).to match_array(%w[quiz_id flag_url hints])
      end

      it "返された国の正しいflag_urlを返す" do
        get "/api/v1/countries/random"
        json = response.parsed_body
        returned_country = Country.find(json["quiz_id"])
        expect(json["flag_url"]).to eq(returned_country.flag_url)
      end

      it "レスポンスにhintsキーを含む" do
        get "/api/v1/countries/random"
        json = response.parsed_body
        expect(json).to have_key("hints")
      end

      it "返された国のすべてのヒントを返す" do
        get "/api/v1/countries/random"
        json = response.parsed_body
        returned_country = Country.find(json["quiz_id"])
        expected_hints = [
          returned_country.hint_1,
          returned_country.hint_2,
          returned_country.hint_3,
          returned_country.hint_4
        ].compact
        expect(json["hints"]).to eq(expected_hints)
      end
    end

    # RSpec/ContextWording: context は "when/with/without" で始める
    context "when no countries exist" do
      # このテストの前にDBを空にする
      before { Country.destroy_all }

      it "404 not_foundステータスを返す" do
        get "/api/v1/countries/random"
        expect(response).to have_http_status(:not_found)
      end

      it "エラーメッセージを返す" do
        get "/api/v1/countries/random"
        json = response.parsed_body
        expect(json["error"]).to eq("No countries available.")
      end
    end
  end
end
