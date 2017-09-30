defmodule Exsite.Helpers.TimeHelper do
  require IEx
  use Timex

  def from_now(datetime) do
    Timex.from_now(datetime, "zh_CN")
  end

  def time_formatter(datetime) do
    date = Timex.to_date(datetime)
    time = Timex.format!(datetime, "%H:%M", :strftime)
    diff = Timex.diff(date, Timex.today)
    cond do
      diff == 0 ->
        "今天 #{time}"
      diff >= -86400000000 and diff < 0 ->
        "昨天 #{time}"
      diff >= 172800000000 and diff < 86400000000 ->
        "前天 #{time}"
      true ->
        Timex.format!(datetime, "%Y-%m-%d %H:%M", :strftime)
    end
  end
end
