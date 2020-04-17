defmodule Rabbit do
    def wait_for_messages do
        IO.puts "------------------------------------wait_for_messages-------------------------------------"
        channel_name = "test_queue"
        options = [username: "rabbitmq_dev", password: "R4bb1tmq_d3v", host: "ec2-13-230-225-193.ap-northeast-1.compute.amazonaws.com", port: 5672] 
        {:ok, connection} = AMQP.Connection.open(options)
        {:ok, channel} = AMQP.Channel.open(connection)
        AMQP.Queue.declare(channel, channel_name)
        AMQP.Basic.consume(channel, channel_name, nil, no_ack: true)
        Agent.start_link(fn -> [] end, name: :batcher)
        _wait_for_messages()
      end
    
    
      defp _wait_for_messages do
        IO.puts "------------------------------------_wait_for_messages-------------------------------------"
        receive do
            {:basic_deliver, payload, meta} -> IO.puts "received a message! 1st" <> payload
            {:ok, payload, _meta} -> IO.puts "received a message! 2nd" <> payload
            {_, _, _} -> IO.puts "else"
        end
        _wait_for_messages()
      end
end      