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
    change LiveFridge.Changes.SetColor, on: :create
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :word, :string do
      allow_nil? false
      public? true
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
