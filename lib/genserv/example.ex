defmodule Example do
    # def add(a, b) do
    #     IO.puts a+b
    # end

    def listen do
        receive do
            {:ok, "hello"}  -> IO.puts "----> World"
            {:ok, "pid"}    -> IO.inspect to_string(self())
            _               -> IO.puts "----! What did you say?"
        end
        listen()
    end

    def pid? do 
        self()
    end

    def send do
        {:ok, "OK"} = Redix.command(:redix, ["SET", "mykey", "foo"])
    end

    def get do 
        {:ok, val} = Redix.command(:redix, ["GET", "mykey"])
        IO.inspect val
    end
end
    # def stop, do: exit (:kaboom)

    # def run do
    #     Process.flag(:trap_exit, true)
    #     spawn_link(Example, :stop [])
    # end
