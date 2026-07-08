

class BarSerializer
  include JSONAPI::Serializer

  Resource = Data.define(:id, :name, :x, :y, :distance)

  attributes :name, :x, :y, :distance

  def self.from_hashes(hashes)
    resources = hashes.map { |h| Resource.new(**h) }
    new(resources, is_collection: true).serializable_hash
  end
end