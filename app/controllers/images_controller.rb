class ImagesController < ApplicationController
  def create
    if image = Image.create(report_id: params[:report_id], file: params[:image])
      head 201, {
        location: report_image_path(report_id: image.report_id, id: image.id),
        image_id: image.id
      }
    else
      head 422
    end
  end

  def show
    image = Image.where(report_id: params[:report_id], id: params[:id]).first or raise_404
    if params[:size]
      redirect_to image.file.url(params[:size])
    else
      redirect_to image.file.url
    end
  end

  def destroy
    image = Image.where(report_id: params[:report_id], id: params[:id]).first or raise_404

    if image.destroy
      head 200
    else
      head 422
    end
  end
end
