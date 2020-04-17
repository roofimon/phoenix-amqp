defmodule Publisher do
    def send do
        options = [username: "rabbitmq_dev", password: "R4bb1tmq_d3v", host: "ec2-13-230-225-193.ap-northeast-1.compute.amazonaws.com", port: 5672] 
        {:ok, conn} = AMQP.Connection.open(options)
        {:ok, chan} = AMQP.Channel.open(conn)
        AMQP.Basic.publish chan, "gen_server_test_exchange", "", "444444"
        # {:ok, payload, meta} = AMQP.Basic.get chan, "gen_server_test_exchange"
    end

    def get do
        options = [username: "rabbitmq_dev", password: "R4bb1tmq_d3v", host: "ec2-13-230-225-193.ap-northeast-1.compute.amazonaws.com", port: 5672] 
        {:ok, conn} = AMQP.Connection.open(options)
        {:ok, chan} = AMQP.Channel.open(conn)
        {:ok, payload, _meta} = AMQP.Basic.get chan, "gen_server_test_queue_error"
        IO.inspect payload
        # {:ok, payload, meta} = AMQP.Basic.get chan, "gen_server_test_exchange"
    end
end
    