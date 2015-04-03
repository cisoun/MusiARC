class MusicsController < ApplicationController

    before_action :set_music, only: [:show, :edit, :update, :destroy]
    before_filter :check_permission, only: [:edit, :update, :destroy]
    layout false

    # GET /musics
    # GET /musics.json
    def index
        @musics = Music.all

        #if params[:search]
        # @musics = Music.search params[:search]#.order("created_at DESC")
        #else
        # @musics = Music.all#.order('created_at DESC')
        #end
    end


    def indexUser
        @user = current_user
        @musics=Music.songsByUser current_user.id
        render 'index', layout: "player"
    end

    def indexLast
        @user = current_user
        @musics = Music.lastSong
        render 'index', layout: "player"
    end

    def search
        @user = current_user
        @musics = Music.search params[:search]#.order("created_at DESC")
        render 'index', layout: "player"
    end


    # GET /musics/1
    # GET /musics/1.json
    def show
        @userId = Music.userId params[:id]

        @music = Music.find(params[:id])

        @comments = @music.comments
        @comment = @music.comments.build

        @playlists = Playlist.all
        @musicPlaylists = @music.music_playlists
        @musicPlaylist = @music.music_playlists.build

        respond_to do |format|
            format.json { render json: { :infos => @music, :path => @music.path.url[0...-11] } }
        end

    end

    # PATCH/PUT /musics/1
    # PATCH/PUT /musics/1.json
    def update
        respond_to do |format|
            if @music.update(music_params)
                format.html { redirect_to @music, notice: 'Your song was successfully updated.' }
                format.json { render :show, status: :ok, location: @music }
            else
                format.html { render :edit }
                format.json { render json: @music.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /musics/1
    # DELETE /musics/1.json
    def destroy
        @music.destroy
        respond_to do |format|
            format.html { redirect_to musics_url, notice: 'Your song has been deleted' }
            format.json { head :no_content }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_music
        @music = Music.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def music_params
        #params[:music].require(:title, :path).permit(:title, :artist, :album, :path, :cover)
        params[:music].permit(:title, :artist, :album, :path, :cover)
    end

    # Check user permission for the actions
    def check_permission
        @userId = Music.userId params[:id]

        redirect_to root_path, notice: 'You dont have enough permissions to be here' unless @user.id==current_user.id
    end
end
