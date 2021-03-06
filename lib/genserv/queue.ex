defmodule SimpleQueue do
    use GenServer
    use AMQP
    require Logger

    @exchange    "gen_server_test_exchange"
    @queue       "gen_server_test_queue"
    @queue_error "#{@queue}_error"

    def init(_opts) do
        # {:ok, conn} = Connection.open("amqp://rabbitmq_dev:R4bb1tmq_d3v@ec2-13-230-225-193.ap-northeast-1.compute.amazonaws.com")
        {:ok, conn} = Connection.open
        {:ok, chan} = Channel.open(conn)
        setup_queue(chan)
    
        # Limit unacknowledged messages to 10
        :ok = Basic.qos(chan, prefetch_count: 10)
        # Register the GenServer process as a consumer
        {:ok, _consumer_tag} = Basic.consume(chan, @queue)
        {:ok, chan}
    end    

  
    defp setup_queue(chan) do
        {:ok, _} = Queue.declare(chan, @queue_error, durable: true)
        # Messages that cannot be delivered to any consumer in the main queue will be routed to the error queue
        {:ok, _} = Queue.declare(chan, @queue,
                                    durable: true,
                                    arguments: [
                                    {"x-dead-letter-exchange", :longstr, ""},
                                    {"x-dead-letter-routing-key", :longstr, @queue_error}
                                    ]
                                )
        :ok = Exchange.fanout(chan, @exchange, durable: true)
        :ok = Queue.bind(chan, @queue, @exchange)
    end

    defp consume(channel, tag, redelivered, payload) do
        Logger.debug("-------------------------------->Consumed")
        number = payload #String.to_integer(payload)
        :ok = Basic.ack channel, tag
        Logger.debug("-------------------------------->Consumed a #{number}.")
    end    
  
    @doc """
    GenServer.handle_call/3 callback
    """
    # Confirmation sent by the broker after registering this process as a consumer
    def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, chan) do
        Logger.debug("-------------------------------->handle_info basic_consume_ok")
        {:noreply, chan}
      end
    
    # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
    def handle_info({:basic_cancel, %{consumer_tag: consumer_tag}}, chan) do
        Logger.debug("-------------------------------->handle_info basic_cancel")
        {:stop, :normal, chan}
    end

    # Confirmation sent by the broker to the consumer process after a Basic.cancel
    def handle_info({:basic_cancel_ok, %{consumer_tag: consumer_tag}}, chan) do
        Logger.debug("-------------------------------->handle_info basic_cancel_ok")
        {:noreply, chan}
    end

    def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, chan) do
    # You might want to run payload consumption in separate Tasks in production
        Logger.debug("-------------------------------->handle_info basic_deliver")
        consume(chan, tag, redelivered, payload)
        {:noreply, chan}
    end
  
    ### Client API / Helper functions
  
    def start_link(state \\ []) do
        GenServer.start_link(__MODULE__, state, name: __MODULE__)
    end
  end