####camera.pixelWidth/nearClipPlane/farClipPlane

####Camera.ScreenToViewportPoint


Viewport space is normalized and relative to the camera. The bottom-left of the camera is (0,0); the top-right is (1,1). The z position is in world units from the camera.


	// When attached to a GUITexture object, this will
	// move the texture around with the mouse.

	function Update () {
		transform.position = Camera.main.ScreenToViewportPoint(Input.mousePosition);
	}
	
	
	


###Orthello 2D Framework:  
Unity3D有几个不同的精灵插件可用，其中最受欢迎的而且我也很广泛的使用的就是Sprite Manager 2。我在早起的一些2D游戏中都使用到了它。不过最近，由于一个朋友提到他对Orthello非常满意，于是我也开始尝试。从某些方面来说，它并不能像使用其他插件那样简单方便的来使用--- 例如，我们不得不制作自己的Sprite Atlases。但是作为一个免费的插件，它提供了更多很棒的特性，能够完美的制作我们的2D游戏。

###iTween:
  iTween 是我所有项目都会使用到的动画系统。对于从敌人到UI等方面的动画来说，它是一个完美的解决方案。并且它也是我开始一个新项目，第一个会安装的脚本。

###A* Pathfinding Project:
A* Pathfinding也是是Unity3D中，使用最广泛的寻径系统。它寻径很快，很强大，而且易于使用。并且它有一个免费的版本，可以完美的使用在我们的项目中。

###TexturePacker:
TexturePacker是一个单独的应用软件。它可以让我们更简单的通过我们的Texture创建Sprite Sheets。虽然你可以使用类似与PhotoShop，acorn 或者Gimp来制作你自己的贴图集，不过Orthello 2D最近开始直接支持TexturePacker生成的贴图集，这让我们的工作变得更加简单。
 
 
 
#####安装Orthello 2D
    在Window-> Asset Store中打开Asset Store，  搜索orthello2D，然后下载最新的版本。然后导入到项目中。

  
#####Orthello 2D初始化设置

    在Orthello的官网上，有很多详细的信息告诉你如何设置并与插件进行工作。下面我将告诉你一些简单的步骤。
      
      为了让Orthello在Scene中工作，你必须设置一些东西。记住，你将会重复下面的步骤在你创建的每一个Scene中。

       1.在Unity Project的视图中， 点击 Orthello->Objects 然后拖动OT prefab到Scene的视图中。

       OT prefab相当如我们在稍后会添加的动画和精灵的容器。在将OT prefab添加到场景后，将会自动对我们的Main Camera做一些改变来让它很好的为2D游戏工作。最重要的一点是，它将投影方式改变为Orthographic  然后将Size设置为332。（332是一个有点古怪的大小，但那就是Orthello所使用）。译者注: 目前的版本应该是设置为384了。

#####安装iTween

     打开Asset Store，然后搜索iTween，并导入到项目中。(译者注: 原文太过啰嗦，只好一句话带过)

    
     安装A* Pathfinding

     点击这个网址:http://arongranberg.com/astar/ 下载A* Pathfinding的免费版本，然后导入到项目中。


#####A* Pathfinding初始化设置

        首先请确定已经阅读了A* Pathfinding文档中的 "getting started"章节。这里将会对如何设置A*有一个完整的描述。不过，我在这里依然会告诉你简单的步骤。

       1.创建一个空的Object

       2.确定这个object的x，y，z的位置均为0，将它重命名为A*。

       3.通过Component->Pathfinding->Pathfinder将Astar的脚本加入到object中。

       4.在Hierarchy中选中A*的object，你应该可以在Inspector视图中看到Astar Path脚本的设置。在脚本的最上面你可以看到一个字符串“Do you want to enable Javascript support?",由于我们教程中所有的脚本将会使用C#来写，这里我们点 No 。