defmodule JsonFormatter do
  def format(level, message, ts, metadata) do
    try do
      log =
        LogParams.encode(ts, level, message, metadata)
        |> Jason.encode!()

      log <> "\n"
    rescue
      e ->
        log =
          %{
            "timestamp" => NaiveDateTime.to_iso8601(NaiveDateTime.utc_now(), :extended) <> "Z",
            "message" => "LogflareLogger formatter error: #{inspect(e, safe: true)}",
            "metadata" => %{
              "formatter_error_params" => %{
                "metadata" =>
                  inspect(metadata, safe: true, limit: :infinity, printable_limit: :infinity),
                "timestamp" => inspect(ts),
                "message" => inspect(message),
                "level" => inspect(level)
              },
              "level" => "error"
            }
          }
          |> Jason.encode!()

        log <> "\n"
    end
  end
end
