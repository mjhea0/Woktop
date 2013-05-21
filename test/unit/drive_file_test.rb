# == Schema Information
#
# Table name: drive_files
#
#  id            :integer          not null, primary key
#  drive_user_id :integer
#  file_id       :string(255)
#  download_link :string(255)
#  name          :string(255)
#  fileType      :string(255)
#  description   :string(255)
#  size          :float
#  path          :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class DriveFileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
