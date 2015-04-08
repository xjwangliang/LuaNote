####cocos2d-x读取txt文本中的数字并转换为整形数组
```
txt中的文本数据为

8
10
12
11
15
13
12
15
16
15
16
18

void txtToint() {
    //获取文件路径。
    std::string path = FileUtils::getInstance()->fullPathForFilename("unit_number.txt");
    
    //创建文件缓冲区及缓冲区大小。
    unsigned char * buffer = NULL;
    unsigned long bufferSize = 0;
    
    //获取文件内容。
    buffer = FileUtils::getInstance()->getFileData(path.c_str(), "r", &bufferSize);
    buffer[bufferSize] = '\0';
    
    //字符串分割
    char * p = strtok((char *)buffer, "\n");
    int i = 0;
    while(p)
    {
        //字符串转数字
        a[i] = atoi(p);
        i++;
        p = strtok(NULL, "\n");
    }
    //清除缓冲区。
    delete [] buffer;
    buffer = NULL;
}
```
###cocos2d-x开关菜单
```
bool HelloWorldScene::init()
{
    m_music_on = MenuItemImage::create("music_on_normal.png",
                                       "music_on_normal.png");
    m_music_off = MenuItemImage::create("music_off_normal.png",
                                        "music_off_normal.png");
    m_music = MenuItemToggle::createWithCallback(CC_CALLBACK_1(HelloWorldScene::menuCallback, this),
                                                 m_music_on,
                                                 m_music_off,
                                                 NULL);
    
    m_music->setPosition(Point(m_visibleSize.width + m_visibleOrigin.x - m_music->getContentSize().width/2,
                               m_visibleOrigin.y + m_music->getContentSize().height/2));
    
    m_sound = Menu::create(m_music, NULL);
    m_sound->setPosition(Point::ZERO);
    this->addChild(m_sound);
}
void HelloWorldScene::menuCallback(Object * pSender)
{
            if(0 == m_music->getSelectedIndex())
            {
               log("开启音乐");
            }
            if(1 == m_music->getSelectedIndex())
            {
                log("关闭音乐");
            }
}
```