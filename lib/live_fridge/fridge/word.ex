defmodule LiveFridge.Fridge.Word do
  use Ash.Resource,
    otp_app: :live_fridge,
    domain: LiveFridge.Fridge,
    data_layer: Ash.DataLayer.Ets,
    notifiers: [LiveFridge.PubSubNotifier]

  actions do
    defaults [:read, :destroy, create: [:word, :x, :y], update: [:x, :y]]
  end

  changes do
    change {LiveFridge.Changes.SetColor, on: :create} do
      where [negate(one_of(:word, ["", nil]))]
    end
  end

  validations do
    validate {LiveFridge.Validations.IsProfanity, on: :create} do
      where [negate(one_of(:word, ["", nil]))]
    end
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :word, :string do
      allow_nil? false
      public? true

      constraints min_length: 1,
                  max_length: 50,
                  trim?: true,
                  allow_empty?: false
    end

    attribute :x, :integer do
      allow_nil? false
      public? true
    end

    attribute :y, :integer do
      allow_nil? false
      public? true
    end

    attribute :color, :string do
      allow_nil? false
      public? true
    end

    timestamps()
  end
end
