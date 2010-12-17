Factory.define :game do |f|
  f.sequence(:tracker_story_id) {|n| n}
  f.tracker_estimate 2
end
