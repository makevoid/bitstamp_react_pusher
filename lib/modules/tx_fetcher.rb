module TxFetcher
  WS_ENDPOINT = 'wss://ws.pusherapp.com/app/de504dc5763aeef9ff52?protocol=7&client=js&version=2.1.6&flash=false'

  def load_transactions
    tx_viz = self
    Browser::Socket.new WS_ENDPOINT do
      on :open do
        puts '{ "event": "pusher:subscribe", "data": { "channel": "diff_order_book" } }'
      end

      on :message do |e|
        data = `JSON.parse(e.native.data)`

        if `data.event` == "data"

          data  = `JSON.parse(data.data)`


          bids = `data.bids`
          asks = `data.asks`

          bids = bids.map{ |price, volume| [price.to_f, volume.to_f] }.select{ |price, volume| volume > 0 }
          asks = asks.map{ |price, volume| [price.to_f, volume.to_f] }.select{ |price, volume| volume > 0 }

          # `console.log('bids', bids)`
          # `console.log('asks', asks)`

          tx_viz.bids = (tx_viz.bids + bids).sort_by{ |price, volume| -price } unless bids.empty?
          tx_viz.asks = (tx_viz.asks + asks).sort_by{ |price, volume| price  } unless asks.empty?

          # tx_viz.bids.push bids


          # data  = `JSON.parse(e.native.data).x`
          # out   = `data.out`
          # hash  = `data.hash`
          # value = out.map{ |o| `o.value` / 10 ** 8 }.inject :+
          # value = value.round 8
          # tx    = { value: value, hash: hash }
          #
          # comp_num = 100
          # tx_gone = tx_viz.transactions[comp_num+1]
          #
          # if tx_gone
          #   # TODO: look at ref
          #   reactid = ".0.3.$#{tx_gone[:hash]}"
          #   # React.findDOMNode
          #   elem_gone = `document.querySelector("div[data-reactid='"+reactid+"']")`
          #   `React.unmountComponentAtNode(elem_gone)`
          # end
          # # tx_viz.transactions.push tx
          # tx_viz.transactions = [tx] + tx_viz.transactions[0..comp_num]
          # tx_viz.total_value  = tx_viz.total_value + value
        end
      end
    end
  end
end
