require 'spec_helper'

describe Kodi::Client do
  let(:uri) { "http://xbmc:pass@localhost:8080/jsonrpc" }
  let(:client) { Kodi::Client.new(uri, {'Input' => ['Up'], 'Player' => ['PlayPause']}) }
  subject { client }

  it { is_expected.to be_a Kodi::Client }

  # TODO: Move - integration test
  describe 'input.up' do
    before do
      stub_request(:post, uri).with(
        :body => '{"method":"Input.Up","params":{},"jsonrpc":"2.0","id":"1"}',
        :headers => { 'Content-Type'=>'application/json' }
      ).to_return(
        :status => 200,
        :body => '{"id":"1","jsonrpc":"2.0","result":"OK"}',
        :headers => {}
      )
    end

    it 'invokes the expected RPC call' do
      expect(client.input.up).to eq "OK"
    end
  end

  # TODO: Move - integration test
  describe 'player.play_pause' do
    before do
      stub_request(:post, uri).with(
        :body => '{"method":"Player.PlayPause","params":{"playerid":1},"jsonrpc":"2.0","id":"1"}',
        :headers => { 'Content-Type'=>'application/json' }
      ).to_return(
        :status => 200,
        :body => '{"id":"1","jsonrpc":"2.0","result":"OK"}',
        :headers => {}
      )
    end

    it 'invokes the expected RPC call' do
      expect(client.player.play_pause playerid: 1).to eq "OK"
    end
  end

  context 'automatic namespace population' do
    let(:client) { Kodi::Client.new(uri) }

    before do
      stub_request(:post, uri).with(
        :body => '{"method":"JSONRPC.Introspect","params":{},"jsonrpc":"2.0","id":"1"}',
        :headers => { 'Content-Type'=>'application/json' }
      ).to_return(
        :status => 200,
        :body => File.read('spec/assets/JSONRPC.Introspect.json'),
        :headers => {}
      )
    end

    it 'populates namespaces' do
      expect(client.namespaces.keys).to eq([
        "Addons",
        "Application",
        "AudioLibrary",
        "Favourites",
        "Files",
        "GUI",
        "Input",
        "JSONRPC",
        "PVR",
        "Player",
        "Playlist",
        "Profiles",
        "Settings",
        "System",
        "Textures",
        "VideoLibrary",
        "XBMC"
      ])
    end
  end
end
