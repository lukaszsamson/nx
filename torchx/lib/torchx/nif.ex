defmodule Torchx.NIF do
  @moduledoc false
  @on_load :__on_load__

  def __on_load__ do
    case :os.type() do
      {:win32, _} -> DLLLoaderHelper.addDLLDirectory("#{:code.priv_dir(:torchx)}/libtorch")
      _ -> :ok
    end

    path = :filename.join(:code.priv_dir(:torchx), ~c"torchx")
    :erlang.load_nif(path, 0)
  end

  for {op, arity} <- Torchx.__torch__() do
    def unquote(:"#{op}_cpu")(unquote_splicing(Macro.generate_arguments(arity, __MODULE__))),
      do: :erlang.nif_error(:undef)

    def unquote(:"#{op}_io")(unquote_splicing(Macro.generate_arguments(arity, __MODULE__))),
      do: :erlang.nif_error(:undef)
  end

  def mps_is_available(), do: :erlang.nif_error(:undef)
  def cuda_is_available(), do: :erlang.nif_error(:undef)
  def cuda_device_count(), do: :erlang.nif_error(:undef)

  def scalar_type(_tensor), do: :erlang.nif_error(:undef)
  def shape(_tensor), do: :erlang.nif_error(:undef)
  def nbytes(_tensor), do: :erlang.nif_error(:undef)
end
