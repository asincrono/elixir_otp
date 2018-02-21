defmodule Chapter5.Worker do
  def start_link do
    spawn(&loop/0)
  end

  def loop do
    receive do
      :stop ->
        :ok

      msg ->
        IO.puts("#{inspect(msg)}")
        loop()
    end
  end
end
