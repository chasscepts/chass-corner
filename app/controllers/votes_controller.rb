class VotesController < ApplicationController
  def create
    @vote = current_user.votes.new(article_id: params[:article_id])

    if @vote.save
      redirect_to root_path, notice: 'You successfully voted for this article.'
    else
      redirect_to root_path, alert: 'You cannot vote for this article.'
    end
  end
end
