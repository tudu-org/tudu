require 'date'

require 'spec_helper'

describe Tudusched::Manifest do
  before :each do
    @manifest = Tudusched.load_manifest_file 'manifest/test_dispatch_one.json'
  end

  it "should return a Manifest object" do
    @manifest.should be_an_instance_of Tudusched::Manifest
  end

  it "should have a schdule array of ScheduleEntries" do
    @manifest.schedule.should be_an_instance_of Array

    @manifest.schedule.each do |e|
      e.should be_an_instance_of Tudusched::ScheduleEntry
    end
  end

  it "should have a tasks array of Tasks" do
    @manifest.tasks.should be_an_instance_of Array

    @manifest.tasks.each do |e|
      e.should be_an_instance_of Tudusched::Task
    end
  end

  it "should have a start object that is a DateTime" do
    @manifest.start_time.should be_an_instance_of DateTime
    @manifest.end_time.should be_an_instance_of DateTime

    @manifest.tasks.each do |e|
      e.due.should be_an_instance_of DateTime
    end

    @manifest.schedule.each do |e|
      e.start_time.should be_an_instance_of DateTime
      e.end_time.should be_an_instance_of DateTime
    end
  end

  it "should have an array of ScheduleEntrys after scheduling the manifest" do
    @manifest.schedule_tasks

    @manifest.tasks.each do |e|
      e.should be_an_instance_of Tudusched::ScheduleEntry
    end
  end
end
