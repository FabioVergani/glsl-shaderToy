//https://www.shadertoy.com/view/Wd2XDm
vec2 g(float n){
	return vec2(
		  .01*sin(n*40.)+.03*sin(n*13.),
		  .03*cos(n*21.)+.08*cos(n*3.)+1.*n
	 );
}

float f(vec3 p,int l){
	 vec2 q=g(p.z);
	 float m,s=1.,t=-max(abs(p.x+q.x),abs(p.y+q.y));
	 p=fract(p)-.5;
	 for(int i=1;i<l;++i){
		  s*=m=dot(p,p)*.7;
		  p/=m;
		  p.xy=fract(p.xy)-.5;
		  p=p.yzx;
	 }
	 s=clamp(.5+.5*((m=min(m,(length(p)-1.)*s))-t)/.05,.0,1.);
	 return mix(t,m,s)+s*(1.-s)*.05;
}

float h(vec3 p){
	 return min(
		  (
				max(
					 f(p,11),
					 (
						  p.xy+=g(p.z),
						  .012-max(abs(p.x),abs(p.y))
					 )
				)
		  ),
		  (
				p.y+=.01,
				max(abs(p.x),abs(p.y))-.001
		  )
	 );
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){

	 vec2 M=iMouse.xy,R=iResolution.xy,u=2.*(fragCoord/R)-1.;

	 float c,X=M.x,Y=M.y,x=R.x,y=R.y,i=X/x,j=Y/y,l=128.+i*j,t=iTime/20.;

	 R=vec2(i,j)*10.;
	 u.x*=x/y;

	 vec3 p=vec3(c,.1,c),
	 o=vec3(-g(t),t),
	 n=normalize(o),
	 q=normalize(cross(n,p)),
	 r=vec3(u.xy,1.5);

	 vec4 k=vec4(1.,.6,.3,3.);

	 p=vec3(R.x,R.y,c);
	 r.yz*=mat2(c=cos(x=p.y),y=sin(x),-y,c);
	 r.xy*=mat2(c=cos(x=p.z),y=sin(x),-y,c);
	 r.xz*=mat2(c=cos(x=p.x),y=sin(x),-y,c);

	 r=mat3(q,cross(q,n),n)*normalize(r);

	 c=47.;
	 M=vec2(i=t=.0,y=.0001);
	 while(i<l){
		  if(x=h(p=o+r*t),x<y){break;};
		  t+=x*.5;
		  j=++i;
	 };
	 x=dot(
		  -r,
		  normalize(
				vec3(
					 (r=M.yxx,h(p+r)-h(p-r)),
					 (r=M.xyx,h(p+r)-h(p-r)),
					 (r=M.xxy,h(p+r)-h(p-r))
				)
		  )
	 )*.5+c*.01;
	 fragColor=vec4(
		  mix(
				mix(
					 n=k.xxx,
					 clamp(abs(fract((c*f(p,6))+k.xyz)*6.-k.www)-n,.0,1.),
					 1.
				)*(x+pow(x,c)),
				r,
				j/l
		  ),1.
	 );
}
