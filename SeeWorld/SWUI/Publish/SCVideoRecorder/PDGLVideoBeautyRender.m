//
//  PDGLVideoBeautyRender.m
//  pandora
//
//  Created by zhangzhifan on 16/10/31.
//  Copyright © 2016年 Albert Lee. All rights reserved.
//

#import "PDGLVideoBeautyRender.h"

#define MY_SHADER_STRING(x) #x

// 调试opengl
#define GL_DEBUG

#ifdef GL_DEBUG
#define GL_LOGD(...)    printf(__VA_ARGS__)
#else
#define GL_LOGD(...)
#endif

#define GL_ERRORS(line) { GLenum glerr; while((glerr = glGetError())) {\
switch(glerr)\
{\
case GL_NO_ERROR:\
break;\
case GL_INVALID_ENUM:\
GL_LOGD("OGL(" __FILE__ "):: %d: Invalid Enum\n", line );\
break;\
case GL_INVALID_VALUE:\
GL_LOGD("OGL(" __FILE__ "):: %d: Invalid Value\n", line );\
break;\
case GL_INVALID_OPERATION:\
GL_LOGD("OGL(" __FILE__ "):: %d: Invalid Operation\n", line );\
break;\
case GL_OUT_OF_MEMORY:\
GL_LOGD("OGL(" __FILE__ "):: %d: Out of Memory\n", line );\
break;\
} } }

@interface PDGLVideoBeautyRender()
{
    GLuint _filteruniformSamplers;
    GLuint _beautyParam;
    GLuint _uWH;
    GLuint _posMatrix;
    GLuint _rgbaTexture;
    float _posMatrixArray[16];
    int _beauty_level;
    int _is_need_flip_x;

}
@end

enum LIVE_BEAUTY_LEVEL_MX
{
    LIVE_BEAUTY_LEVEL1 = 1,
    LIVE_BEAUTY_LEVEL2 = 2,
    LIVE_BEAUTY_LEVEL3 = 3,
    LIVE_BEAUTY_LEVEL4 = 4,
    LIVE_BEAUTY_LEVEL5 = 5,
    LIVE_BEAUTY_LEVEL_MAX = 6
};


void myGetBeautyParam(GLfloat* fBeautyParam, enum LIVE_BEAUTY_LEVEL_MX level){
    switch (level) {
        case LIVE_BEAUTY_LEVEL1:
            fBeautyParam[0] = 1.0;
            fBeautyParam[1] = 1.0;
            fBeautyParam[2] = 0.15;
            fBeautyParam[3] = 0.15;
            break;
        case LIVE_BEAUTY_LEVEL2:
            fBeautyParam[0] = 0.8;
            fBeautyParam[1] = 0.9;
            fBeautyParam[2] = 0.2;
            fBeautyParam[3] = 0.2;
            break;
        case LIVE_BEAUTY_LEVEL3:
            fBeautyParam[0] = 0.6;
            fBeautyParam[1] = 0.8;
            fBeautyParam[2] = 0.25;
            fBeautyParam[3] = 0.25;
            break;
        case LIVE_BEAUTY_LEVEL4:
            fBeautyParam[0] = 0.4;
            fBeautyParam[1] = 0.7;
            fBeautyParam[2] = 0.38;
            fBeautyParam[3] = 0.3;
            break;
        case LIVE_BEAUTY_LEVEL5:
            fBeautyParam[0] = 0.33/1.5;
            fBeautyParam[1] = 0.63/1.5;
            fBeautyParam[2] = 0.4/1.5;
            fBeautyParam[3] = 0.35/1.5;
            break;
        default:
            break;
    }
}

@implementation PDGLVideoBeautyRender


-(const char*) myGetFragmentShaderString
{
    return MY_SHADER_STRING( precision highp float;
                            
                            uniform sampler2D inputImageTexture;
                            uniform vec2 singleStepOffset;
                            uniform highp vec4 params;
                            
                            varying highp vec2 textureCoordinate;
                            
                            const highp vec3 W = vec3(0.299,0.587,0.114);
                            const mat3 saturateMatrix = mat3(
                                                             1.1102,-0.0598,-0.061,
                                                             -0.0774,1.0826,-0.1186,
                                                             -0.0228,-0.0228,1.1772);
                            
                            float hardlight(float color)
                            {
                                if(color <= 0.5)
                                {
                                    color = color * color * 2.0;
                                }
                                else
                                {
                                    color = 1.0 - ((1.0 - color)*(1.0 - color) * 2.0);
                                }
                                return color;
                            }
                            
                            void main(){
                                vec2 blurCoordinates[24];
                                
                                blurCoordinates[0] = textureCoordinate.xy + singleStepOffset * vec2(0.0, -10.0);
                                blurCoordinates[1] = textureCoordinate.xy + singleStepOffset * vec2(0.0, 10.0);
                                blurCoordinates[2] = textureCoordinate.xy + singleStepOffset * vec2(-10.0, 0.0);
                                blurCoordinates[3] = textureCoordinate.xy + singleStepOffset * vec2(10.0, 0.0);
                                
                                blurCoordinates[4] = textureCoordinate.xy + singleStepOffset * vec2(5.0, -8.0);
                                blurCoordinates[5] = textureCoordinate.xy + singleStepOffset * vec2(5.0, 8.0);
                                blurCoordinates[6] = textureCoordinate.xy + singleStepOffset * vec2(-5.0, 8.0);
                                blurCoordinates[7] = textureCoordinate.xy + singleStepOffset * vec2(-5.0, -8.0);
                                
                                blurCoordinates[8] = textureCoordinate.xy + singleStepOffset * vec2(8.0, -5.0);
                                blurCoordinates[9] = textureCoordinate.xy + singleStepOffset * vec2(8.0, 5.0);
                                blurCoordinates[10] = textureCoordinate.xy + singleStepOffset * vec2(-8.0, 5.0);
                                blurCoordinates[11] = textureCoordinate.xy + singleStepOffset * vec2(-8.0, -5.0);
                                
                                blurCoordinates[12] = textureCoordinate.xy + singleStepOffset * vec2(0.0, -6.0);
                                blurCoordinates[13] = textureCoordinate.xy + singleStepOffset * vec2(0.0, 6.0);
                                blurCoordinates[14] = textureCoordinate.xy + singleStepOffset * vec2(6.0, 0.0);
                                blurCoordinates[15] = textureCoordinate.xy + singleStepOffset * vec2(-6.0, 0.0);
                                
                                blurCoordinates[16] = textureCoordinate.xy + singleStepOffset * vec2(-4.0, -4.0);
                                blurCoordinates[17] = textureCoordinate.xy + singleStepOffset * vec2(-4.0, 4.0);
                                blurCoordinates[18] = textureCoordinate.xy + singleStepOffset * vec2(4.0, -4.0);
                                blurCoordinates[19] = textureCoordinate.xy + singleStepOffset * vec2(4.0, 4.0);
                                
                                blurCoordinates[20] = textureCoordinate.xy + singleStepOffset * vec2(-2.0, -2.0);
                                blurCoordinates[21] = textureCoordinate.xy + singleStepOffset * vec2(-2.0, 2.0);
                                blurCoordinates[22] = textureCoordinate.xy + singleStepOffset * vec2(2.0, -2.0);
                                blurCoordinates[23] = textureCoordinate.xy + singleStepOffset * vec2(2.0, 2.0);
                                
                                
                                float sampleColor = texture2D(inputImageTexture, textureCoordinate).g * 22.0;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[0]).g;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[1]).g;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[2]).g;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[3]).g;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[4]).g;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[5]).g;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[6]).g;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[7]).g;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[8]).g;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[9]).g;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[10]).g;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[11]).g;
                                
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[12]).g * 2.0;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[13]).g * 2.0;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[14]).g * 2.0;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[15]).g * 2.0;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[16]).g * 2.0;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[17]).g * 2.0;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[18]).g * 2.0;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[19]).g * 2.0;
                                
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[20]).g * 3.0;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[21]).g * 3.0;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[22]).g * 3.0;
                                sampleColor += texture2D(inputImageTexture, blurCoordinates[23]).g * 3.0;
                                
                                sampleColor = sampleColor / 62.0;
                                
                                vec3 centralColor = texture2D(inputImageTexture, textureCoordinate).rgb;
                                
                                float highpass = centralColor.g - sampleColor + 0.5;
                                
                                for(int i = 0; i < 5;i++)
                                {
                                    highpass = hardlight(highpass);
                                }
                                float lumance = dot(centralColor, W);
                                
                                float alpha = pow(lumance, params.r);
                                
                                vec3 smoothColor = centralColor + (centralColor-vec3(highpass))*alpha*0.1;
                                
                                smoothColor.r = clamp(pow(smoothColor.r, params.g),0.0,1.0);
                                smoothColor.g = clamp(pow(smoothColor.g, params.g),0.0,1.0);
                                smoothColor.b = clamp(pow(smoothColor.b, params.g),0.0,1.0);
                                
                                vec3 lvse = vec3(1.0)-(vec3(1.0)-smoothColor)*(vec3(1.0)-centralColor);
                                vec3 bianliang = max(smoothColor, centralColor);
                                vec3 rouguang = 2.0*centralColor*smoothColor + centralColor*centralColor - 2.0*centralColor*centralColor*smoothColor;
                                
                                gl_FragColor = vec4(mix(centralColor, lvse, alpha), 1.0);
                                gl_FragColor.rgb = mix(gl_FragColor.rgb, bianliang, alpha);
                                gl_FragColor.rgb = mix(gl_FragColor.rgb, rouguang, params.b);
                                
                                vec3 satcolor = gl_FragColor.rgb * saturateMatrix;
                                gl_FragColor.rgb = mix(gl_FragColor.rgb, satcolor, params.a);
                            });
}


-(const char*) myGetVertexShaderString
{
    return MY_SHADER_STRING(
                            uniform mat4 posMatrix;
                            attribute vec4 position;
                            attribute vec4 inputTextureCoordinate;
                            varying vec2 textureCoordinate;
                            
                            void main()
                            {
                                gl_Position =  posMatrix * vec4(position.xyz, 1.0);
                                textureCoordinate = inputTextureCoordinate.xy;
                            }
                            );
}

- (void) setBeautyLevel:(int)level
{
    if (_beauty_level < LIVE_BEAUTY_LEVEL_MAX && _beauty_level > 0) {
        _beauty_level = level;
    }
}


-(void) setupTexture :(int) width height:(int)height
{
    if (_rgbaTexture > 0) {
        return;
    }
    
    
    if (_rgbaTexture == 0) {
        glGenTextures(1, &_rgbaTexture);
    }
    
    glActiveTexture(GL_TEXTURE0  + 1);
    glBindTexture(GL_TEXTURE_2D, _rgbaTexture);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexImage2D(GL_TEXTURE_2D,
                 0,
                 GL_RGBA,
                 width,
                 height,
                 0,
                 GL_BGRA,
                 GL_UNSIGNED_BYTE,
                 NULL);
}


- (void) updateTexture : (CVPixelBufferRef) ref
{
    
    assert(ref != nil);
    assert(CVPixelBufferGetHeight(ref) > 0);
    assert(CVPixelBufferGetWidth(ref) > 0);
    
    int width = (int) CVPixelBufferGetWidth(ref);
    int height = (int) CVPixelBufferGetHeight(ref);
    
    GL_ERRORS(__LINE__);

    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);

    GL_ERRORS(__LINE__);

    if (0 == _rgbaTexture) {
        [self setupTexture:width height:height];
    }
    
    glActiveTexture(GL_TEXTURE0  + 1);

    GL_ERRORS(__LINE__);

    glUniform1i(_filteruniformSamplers,  1);
    
    GL_ERRORS(__LINE__);

    glBindTexture(GL_TEXTURE_2D, _rgbaTexture);

    GL_ERRORS(__LINE__);

    unsigned char* rawdata = NULL;
    CVPixelBufferLockBaseAddress(ref, 0);
    
    rawdata = (unsigned char*) CVPixelBufferGetBaseAddress(ref);
#if 0
    // 这里是否需要按行进行局部上传纹理
    int bytesPerRow = (int) CVPixelBufferGetBytesPerRow(ref);
    if (bytesPerRow == width * 4) {
        glTexSubImage2D(GL_TEXTURE_2D,
                        0,
                        0,
                        0,
                        width,
                        height,
                        GL_BGRA,
                        GL_UNSIGNED_BYTE,
                        rawdata);
    } else {
        assert(bytesPerRow > width * 4);
        // 按照行进行上传
        for (int i = 0; i < height; i++) {
            unsigned char* row = rawdata + i * bytesPerRow;
            glTexSubImage2D( GL_TEXTURE_2D, 0, 0, i, width, 1, GL_BGRA, GL_UNSIGNED_BYTE, row);
        }
    }
#else
    // 由于这里暂时支持一个格式 kCVPixelFormatType_32BGRA
    // 如果上传其他格式 glTexImage2D 会crash
    OSType type = CVPixelBufferGetPixelFormatType(ref);
    if (type != kCVPixelFormatType_32BGRA) {
        NSLog(@"zz updateTexture == error input CVPixelBufferGetPixelFormatType [%s] ", (const char*)&type);
        assert(false);
    }

    // 直接上传rawdata bgra
    glTexImage2D(GL_TEXTURE_2D,
                 0,
                 GL_RGBA,
                 width,
                 height,
                 0,
                 GL_BGRA,
                 GL_UNSIGNED_BYTE,
                 rawdata);

    GL_ERRORS(__LINE__);
#endif
    CVPixelBufferUnlockBaseAddress(ref, 0);
    
}

- (void) mat4_loadIdentity: (float*) m4
{
    m4[0] = 1.0f;
    m4[1] = 0.0f;
    m4[2] = 0.0f;
    m4[3] = 0.0f;
   
    m4[4] = 0.0f;
    m4[5] = 1.0f;
    m4[6] = 0.0f;
    m4[7] = 0.0f;
    
    m4[8] = 0.0f;
    m4[9] = 0.0f;
    m4[10] = 1.0f;
    m4[11] = 0.0f;
    
    m4[12] = 0.0f;
    m4[13] = 0.0f;
    m4[14] = 0.0f;
    m4[15] = 1.0f;
}

- (void) mat4_loadYRoation: (float*) m4
{
    m4[0] = -1.0f;
    m4[1] = 0.0f;
    m4[2] = 0.0f;
    m4[3] = 0.0f;
    
    m4[4] = 0.0f;
    m4[5] = 1.0f;
    m4[6] = 0.0f;
    m4[7] = 0.0f;
    
    m4[8] = 0.0f;
    m4[9] = 0.0f;
    m4[10] = 1.0f;
    m4[11] = 0.0f;
    
    m4[12] = 0.0f;
    m4[13] = 0.0f;
    m4[14] = 0.0f;
    m4[15] = 1.0f;
    
}

- (void) isFlipXPosition:(int)isNeedFlip
{
    _is_need_flip_x = isNeedFlip;
    
    if (_is_need_flip_x) {
        // 进行X轴翻转
        [self mat4_loadYRoation:_posMatrixArray];
    } else {
        // 不处理坐标
        [self mat4_loadIdentity:_posMatrixArray];
    }
}

- (id) init
{
    NSString *const kGLRenderVertexShaderString = [NSString stringWithUTF8String:[self myGetVertexShaderString]];
    
    NSString *const kGLRenderFragmentShaderString = [NSString stringWithUTF8String:[self myGetFragmentShaderString]];
    
    if (!(self = [super initWithVertexShaderFromString:kGLRenderVertexShaderString fragmentShaderFromString:kGLRenderFragmentShaderString contexName:@"com.baobao.beauty.render"]))
    {
        return nil;
    }
    
    
    runSynchronouslyOnGLProcessingQueue(_glContext, ^{
        [_glContext setActiveShaderProgram:_filterProgram];
        
        _rgbaTexture = 0;
        if (true) {
            _filteruniformSamplers = [_filterProgram uniformIndex:@"inputImageTexture"];
            _beautyParam = [_filterProgram uniformIndex:@"params"];
            _uWH = [_filterProgram uniformIndex:@"singleStepOffset"];
            _posMatrix = [_filterProgram uniformIndex:@"posMatrix"];
            
            [self isFlipXPosition:0];
            // 默认使用4等级美白
            _beauty_level = 4;
        }
    });
    
    return self;
}


- (void) doBeautyRender:(CVPixelBufferRef)ref
{

    if (_rgbaTexture == 0) {
        [self setupTexture:(int)CVPixelBufferGetWidth(ref) height:(int)CVPixelBufferGetHeight(ref)];
    }
    
    static const GLfloat imageVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };
    
    
    static const GLfloat noRotationTextureCoordinates[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
    };
    
    
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    GL_ERRORS(__LINE__);
    
    [self updateTexture:ref];
    GL_ERRORS(__LINE__);

    glUniformMatrix4fv(_posMatrix, 1, GL_FALSE, _posMatrixArray);
    
    GL_ERRORS(__LINE__);
    
    GLfloat fWHArray[2];
    fWHArray[0] = 2.0 / (float) CVPixelBufferGetWidth(ref);
    fWHArray[1] = 2.0 / (float) CVPixelBufferGetHeight(ref);
    glUniform2fv(_uWH, 1, fWHArray);
    
    GLfloat fBeautyParam[4];
    myGetBeautyParam(fBeautyParam, _beauty_level);
    glUniform4fv(_beautyParam, 1, fBeautyParam);
    
    GL_ERRORS(__LINE__);
    
    glVertexAttribPointer(_filterPositionAttribute, 2, GL_FLOAT, 0, 0, imageVertices);
    glVertexAttribPointer(_filterTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, noRotationTextureCoordinates);
    glEnableVertexAttribArray(_filterPositionAttribute);
    glEnableVertexAttribArray(_filterTextureCoordinateAttribute);
    
    GL_ERRORS(__LINE__);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    GL_ERRORS(__LINE__);
    
    glFlush();

}


- (void) dealloc
{
    if (_rgbaTexture > 0) {
        glDeleteTextures(1, &_rgbaTexture);
    }
    
    NSLog(@"PDGLVideoBeautyRender == dealloc !!");
}

@end
