defmodule Xventure.Location do
  def load!(name) do
    YamlElixir.read_from_file!("priv/locs/#{name}.yaml")
  end
end
