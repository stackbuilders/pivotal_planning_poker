module StoriesHelper
  def column_class_for(div_class, collection_size, index)
    ( index + 1 < collection_size ) ? div_class : "#{div_class} last"
  end
end