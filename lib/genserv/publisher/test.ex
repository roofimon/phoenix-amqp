defmodule Publisher do
    def send do
        options = [username: "rabbitmq_dev", password: "R4bb1tmq_d3v", host: "ec2-13-230-225-193.ap-northeast-1.compute.amazonaws.com", port: 5672] 
        {:ok, conn} = AMQP.Connection.open(options)
        {:ok, chan} = AMQP.Channel.open(conn)
        AMQP.Queue.declare chan, "test_queue"
        AMQP.Exchange.declare chan, "test_exchange"
        AMQP.Queue.bind chan, "test_queue", "test_exchange"    
        AMQP.Basic.publish chan, "test_exchange", "", "Message from Venus!!!!"
        # {:ok, payload, meta} = AMQP.Basic.get chan, "test_queue"
    end
end
    