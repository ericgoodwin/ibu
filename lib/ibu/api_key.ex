defmodule IBU.ApiKey do
  @moduledoc """
  Tesla middleware that adds the API key header to every request.

  Read at request time from the `:ibu` application env:

      config :ibu, api_key: "secret", api_key_header: "apikey"

  `api_key_header` defaults to `"apikey"`. No header is sent when `api_key` is unset.
  """
  @behaviour Tesla.Middleware

  @default_header "apikey"

  @impl Tesla.Middleware
  def call(env, next, _opts) do
    env
    |> put_api_key(Application.get_env(:ibu, :api_key))
    |> Tesla.run(next)
  end

  defp put_api_key(env, key) when is_binary(key) and key != "" do
    header = Application.get_env(:ibu, :api_key_header, @default_header)
    Tesla.put_header(env, header, key)
  end

  defp put_api_key(env, _), do: env
end
