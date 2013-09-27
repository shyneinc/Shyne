# Scaffolding generated by Casein v.4.0.0

module Casein
  class MentorsController < Casein::CaseinController
  
    ## optional filters for defining usage according to Casein::Users access_levels
    # before_filter :needs_admin, :except => [:action1, :action2]
    # before_filter :needs_admin_or_current_user, :only => [:action1, :action2]
  
    def index
      @casein_page_title = 'Mentors'
  		@mentors = Mentor.paginate :page => params[:page]
    end
  
    def show
      @casein_page_title = 'View mentor'
      @mentor = Mentor.find params[:id]
    end
 
    def new
      @casein_page_title = 'Add a new mentor'
    	@mentor = Mentor.new
    end

    def create
      @mentor = Mentor.new mentor_params
    
      if @mentor.save
        flash[:notice] = 'Mentor created'
        redirect_to casein_mentors_path
      else
        flash.now[:warning] = 'There were problems when trying to create a new mentor'
        render :action => :new
      end
    end
  
    def update
      @casein_page_title = 'Update mentor'
      
      @mentor = Mentor.find params[:id]
    
      if @mentor.update_attributes mentor_params
        flash[:notice] = 'Mentor has been updated'
        redirect_to casein_mentors_path
      else
        flash.now[:warning] = 'There were problems when trying to update this mentor'
        render :action => :show
      end
    end
 
    def destroy
      @mentor = Mentor.find params[:id]

      @mentor.destroy
      flash[:notice] = 'Mentor has been deleted'
      redirect_to casein_mentors_path
    end
  
    private
      
      def mentor_params
        params.require(:mentor).permit(:first_name, :last_name)
      end

  end
end