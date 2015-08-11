module TxFetcher
  def load_transactions
    tx_viz = self
    Browser::Socket.new 'wss://ws.blockchain.info/inv' do
      on :open do
        puts '{"op":"unconfirmed_sub"}'
      end

      on :message do |e|
        data  = `JSON.parse(e.native.data).x`
        out   = `data.out`
        hash  = `data.hash`
        value = out.map{ |o| `o.value` / 10 ** 8 }.inject :+
        value = value.round 8
        tx    = { value: value, hash: hash }

        comp_num = 100
        tx_gone = tx_viz.transactions[comp_num+1]

        if tx_gone
          # TODO: look at ref
          reactid = ".0.3.$#{tx_gone[:hash]}"
          # React.findDOMNode
          elem_gone = `document.querySelector("div[data-reactid='"+reactid+"']")`
          `React.unmountComponentAtNode(elem_gone)`
        end
        # tx_viz.transactions.push tx
        tx_viz.transactions = [tx] + tx_viz.transactions[0..comp_num]
        tx_viz.total_value  = tx_viz.total_value + value
      end
    end
  end
end
