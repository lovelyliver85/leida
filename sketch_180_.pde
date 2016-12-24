import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port

//base config
int mWidth = 1800;//huabuchangdu
int mHeight = 900;//huabugaodu
int mWidthHalf = mWidth / 2;
int mHeightHalf = mHeight / 2;
int mBlock = 40;
int mBlockOffset = mWidth / mBlock;//30

float mMaxDistance = mWidth / 18.0f;


//current angle 
int mAngleNum = 0;
//current distance
int mDistanceNum = 0;
int jishu1=1;
int jishu2=1;
//all distance 
int[] mDistanceArr = new int[100000];
void setup() 
{
  size(1800, 900);
  frameRate(60);//shezhi zhenpin

  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  background(0);
}

void draw()

{
  
  jishu1=jishu1+jishu2;
  if(jishu1>=180||jishu1<=0)
  jishu2=-jishu2;
  
  if ( myPort.available() > 0) 
  { 
    val = myPort.read();
    while(val!='<')
     val=myPort.read();
    if( val == '<')
   {
      mAngleNum = 0;
      mDistanceNum = 0;
      while( ( val = myPort.read() ) != '|' )
      {
        if ((val>='0') && (val<='9'))
        {
        mAngleNum = 10 * mAngleNum + val - '0';
        }
      }

      while( ( val = myPort.read() ) != '>' )
      {
        if ((val>='0') && (val<='9'))
        {
               mDistanceNum = 10 * mDistanceNum + val - '0';
        }
      }
      
      
      
     if(mAngleNum>180||mAngleNum<0)
     {
                mAngleNum=0;
                
  
      }

      if( mDistanceNum > 150)
       {
         mDistanceArr[mAngleNum] = -1;
       }
       else
       {
         mDistanceArr[mAngleNum] = mDistanceNum;
       
        }
    }
    
    
      //draw background line
  drawBg();
  
  //scan angle
  drawScan(jishu1);
  
  //distance
  drawBarrier();
    
    
  }
  
  
  
  
  
  
  else
  {
   
   drawBg();
  
  //scan angle
  drawScan(jishu1);
  }
  
  



}




























void drawBg()//bei jing
{
  background(0);//bei jing yan se
  //print("draw bg");
  stroke(21,113,10, 51);//bian kuang yan se
  //line(0, 0,  300, 300);
  for( int x = 0; x < mBlockOffset; ++x )
  {
    //print("line:" + x * mBlock);
    line(0, x * mBlock, mWidth, x * mBlock );
    line(x*mBlock, 0, x * mBlock, mHeight );
    if( x % 5 == 0 )
    {
      stroke(21,113,10, 250);
      line(0, x * mBlock, mWidth, x * mBlock );
      line(x*mBlock, 0, x * mBlock, mHeight );
      stroke(21,113,10, 51);
    }
    
    
  }
  
  stroke(21,113,10, 200);
  fill(21,113,10, 200);
  arc( mWidthHalf, mHeight, mBlock, mBlock, PI, PI * 2, PIE);//hua yuan hu
  stroke(21,113,10, 254);
  noFill();
  arc( mWidthHalf, mHeight, mWidth, mWidth, PI, PI * 2, PIE);
  
}







void drawScan( int num )
{  

  println( "angle:" + num );

  noStroke();
  fill(21,113,10, 50);
  arc( mWidthHalf, mHeight, mWidth, mWidth, PI + ( num/ 180.0f - 0.1f ) * PI, PI + ( num/ 180.0f + 0.1f ) * PI, PIE);
}












void drawBarrier()//hua zhang ai wu
{
  //println( "distance:" + num);
  noStroke();//mei you bian kuang
  fill(21,113,10, 254);
  for( int i = 0; i < 181; i ++ )
  { 
    int a, b, distance;
    distance = a = b = mDistanceArr[i];
    
    if( i - 1 >= 0 )
      a = mDistanceArr[ i - 1 ];
    if( i + 1 <= 181)
      b = mDistanceArr[ i + 1 ];
    if( distance < 5 || distance > mMaxDistance ) continue;
    if( a < 5 || a > mMaxDistance ) a = distance;
    if( b < 5 || b > mMaxDistance ) b = distance;
    
    distance = (a + b + distance) / 3;
    
    if( distance < 5 || distance >= mMaxDistance ) continue;
    //distance = 60 angle = 45;
    //mWidth / 2;
    float scale = mWidthHalf / mMaxDistance;
    
    int tmpDistance = (int)(distance * scale);
    
    
    int px = (int)(mWidthHalf - tmpDistance * cos(i * PI/181));
    int yy = (int)(tmpDistance * sin(i * PI/181));
    int py = 900 - yy;
    println("scale:" + scale + " angle:" + i + " sin():" + sin(i * PI/181) + " distance:" + distance + " tmpDistance:" + tmpDistance + " x:" + px + " yy:" + yy + "  py:" + py);
    
    ellipse(px, py, 30, 30);
  }
  
}