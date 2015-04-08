class Metova::S3Controller < Metova::ApplicationController
  respond_to :json

  def presigned_url
    if defined? Refile
      signature = Refile.store.presign
      respond_with signature
    else
      respond_with Metova::GenericError.new('Server maintainer must install Refile before using S3 direct uploads!')
    end
  end

end
