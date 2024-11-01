defmodule LiveFridge.Fridge.Fridge do
  use Ash.Resource,
    otp_app: :live_fridge,
    domain: LiveFridge.Fridge,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:read, :destroy, create: [:name]]
  end

  preparations do
    prepare build(load: :words)
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    timestamps()
  end

  relationships do
    has_many :words, LiveFridge.Fridge.Word do
      public? true
    end
  end

  identities do
    identity :name, [:name], pre_check?: true
  end
end
