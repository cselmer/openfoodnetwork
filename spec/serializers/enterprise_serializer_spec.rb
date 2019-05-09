require 'spec_helper'

describe Api::EnterpriseSerializer do
  let(:serializer) { Api::EnterpriseSerializer.new enterprise, data: data }
  let(:enterprise) { create(:distributor_enterprise) }
  let(:taxon) { create(:taxon) }
  let(:data) { OpenStruct.new(earliest_closing_times: {},
                              active_distributors: [],
                              all_distributed_taxons: {enterprise.id => [123]},
                              current_distributed_taxons: {enterprise.id => [123]},
                              supplied_taxons: {enterprise.id => [456]},
                              shipping_method_services: {},
                              relatives: {enterprise.id => {producers: [123], distributors: [456]}}) 
  }

  it "serializes an enterprise" do
    expect(serializer.to_json).to match enterprise.name
  end

  it "serializes taxons as ids only" do
    expect(serializer.serializable_hash[:taxons]).to eq([{id: 123}])
    expect(serializer.serializable_hash[:supplied_taxons]).to eq([{id: 456}])
  end

  it "serializes producers and hubs as ids only" do
    expect(serializer.serializable_hash[:producers]).to eq([{id: 123}])
    expect(serializer.serializable_hash[:hubs]).to eq([{id: 456}])
  end

  it "serializes icons" do
    expect(serializer.to_json).to match "map_005-hub.svg"
  end
end
