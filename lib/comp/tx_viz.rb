class TxViz
  include React::Component
  include TxFetcher
  after_mount :load_transactions
  after_mount :reset_timer

  define_state(:timer)        { `new Date()` }
  define_state(:bids) { [] }
  define_state(:asks) { [] }

  def reset_timer
    self.timer = `new Date()`
  end

  def render
    div do
      div className: "header" do
        h3 { "Bitstamp Orderbook live trades" }
        p className: "mini" do
          "realtime orderbook trades visualizer, bitstamp - powered by opal, react, css3, websockets"
        end
      end
      div className: "right_panel" do
        div className: "theme colors" do
          p { "theme colors" }
          p { "[  ] light" }
          p { "[ x ] color" }
          p { "[  ] dark" }
          p { "[  ] desaturated" }
          p { "[  ] invert" }
        end
      end
      div className: "tx_list" do
        h3 { "Bids" }
        self.bids.each_with_index.map do |trade, idx|
          price, volume = trade
          comp = present Transaction, price: price, volume: volume, key: "bid-#{idx}"
          comp
        end
        h3 { "Asks" }
        self.asks.each_with_index.map do |trade, idx|
          price, volume = trade
          comp = present Transaction, price: price, volume: volume, key: "ask-#{idx}"
          comp
        end
      end
    end
  end
end
