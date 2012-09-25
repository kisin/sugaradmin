class Asset < ActiveRecord::Base
  before_create :generate_access_token
  after_destroy :tag_as_primary_if_no_primary_exists
  after_save :tag_as_primary_if_no_primary_exists
  after_create :tag_as_primary_if_no_primary_exists

  belongs_to :user

  has_attached_file :item,
      :storage => :s3,
      :bucket => ENV['S3_BUCKET_NAME'],
      :s3_credentials => {
        :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
        :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
      },
      :styles => {
        :small => '160x120#',
        :medium => '260x180#',
        :large => '360x268#'
      },
      :url => '/:access_token/:id_:style.:extension',
      :path => '/:access_token/:id_:style.:extension'

  validates_attachment :item, :presence => true,
                                    :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"] },
                                    :size => { :in => 0..4.megabyte }


  def primary?
    return true if is_primary>0
    false
  end



  protected

  # mark first picture as primary if no other pictures is primary
  def tag_as_primary_if_no_primary_exists
    assets = user.assets
    if assets.count>0
      user.profile.update_attribute("hasimages", 1)
      assets.first.update_attribute('is_primary', 1) if assets.where('"is_primary"=1').count==0
    else
      user.profile.update_attribute("hasimages", 0)
    end
  end




  private

  # simple random salt
  def random_salt(len = 20)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    salt = ""
    1.upto(len) { |i| salt << chars[rand(chars.size-1)] }
    return salt
  end

  # SHA1 from random salt and time
  def generate_access_token
    self.access_token = Digest::SHA1.hexdigest("#{random_salt}#{Time.now.to_i}").to_s
  end

end
