defmodule Chapter5.Ring do
  def create_processes(n) do
    1..n
    |> Enum.map(fn _ ->
      spawn(&loop/0)
    end)
  end

  def loop do
    receive do
      {:link, pid} ->
        Process.link(pid)
        loop()

      :exit ->
        Process.exit(self(), :normal)

      :trap_exit ->
        Process.flag(:trap_exit, true)
        loop()

      {:EXIT, pid, reason} ->
        IO.puts("#{inspect(self())} received {:EXIT, #{inspect(pid)}, #{reason}}")
        loop()

      :crash ->
        1 / 0
    end
  end

  def link_processes(procs) do
    do_link_processes(procs, [])
  end

  defp do_link_processes([proc1, proc2 | t], linked_processes) do
    send(proc1, {:link, proc2})
    do_link_processes([proc2 | t], [proc1 | linked_processes])
  end

  defp do_link_processes([proc | []], linked_processes) do
    last_proc = List.first(linked_processes)
    send(proc, {:link, last_proc})
  end
end
