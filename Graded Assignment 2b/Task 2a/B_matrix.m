function B = B_matrix(in1,in2,in3,in4,in5)
%B_matrix
%    B = B_matrix(IN1,IN2,IN3,IN4,IN5)

%    This function was generated by the Symbolic Math Toolbox version 24.2.
%    04-Mar-2025 17:15:12

xe11 = in2(1,:);
xe12 = in2(2,:);
xe21 = in3(1,:);
xe22 = in3(2,:);
xe31 = in4(1,:);
xe32 = in4(2,:);
xe41 = in5(1,:);
xe42 = in5(2,:);
xi1 = in1(1,:);
xi2 = in1(2,:);
t2 = xe11.*xe22;
t3 = xe12.*xe21;
t4 = xe11.*xe42;
t5 = xe12.*xe41;
t6 = xe21.*xe32;
t7 = xe22.*xe31;
t8 = xe31.*xe42;
t9 = xe32.*xe41;
t10 = xe11.*xi1;
t11 = xe11.*xi2;
t12 = xe12.*xi1;
t13 = xe12.*xi2;
t14 = xe21.*xi1;
t15 = xe21.*xi2;
t16 = xe22.*xi1;
t17 = xe22.*xi2;
t18 = xe31.*xi1;
t19 = xe31.*xi2;
t20 = xe32.*xi1;
t21 = xe32.*xi2;
t22 = xe41.*xi1;
t23 = xe41.*xi2;
t24 = xe42.*xi1;
t25 = xe42.*xi2;
t26 = xe11.*2.0;
t27 = xe12.*2.0;
t28 = xe21.*2.0;
t29 = xe22.*2.0;
t30 = xe31.*2.0;
t31 = xe32.*2.0;
t32 = xe41.*2.0;
t33 = xe42.*2.0;
t34 = xi1.*2.0;
t35 = xi2.*2.0;
t36 = xi1+1.0;
t37 = xi2+1.0;
t38 = xi1.^2;
t39 = xi2.^2;
t74 = -xe21;
t76 = -xe22;
t82 = -xe41;
t84 = -xe42;
t86 = -xi1;
t87 = -xi2;
t88 = xi1-1.0;
t89 = xi2-1.0;
t40 = t10.*2.0;
t41 = t11.*2.0;
t42 = t12.*2.0;
t43 = t13.*2.0;
t44 = t14.*2.0;
t45 = t15.*2.0;
t46 = t16.*2.0;
t47 = t17.*2.0;
t48 = t18.*2.0;
t49 = t19.*2.0;
t50 = t20.*2.0;
t51 = t21.*2.0;
t52 = t22.*2.0;
t53 = t23.*2.0;
t54 = t24.*2.0;
t55 = t25.*2.0;
t56 = t2.*xi2;
t57 = t3.*xi2;
t58 = t10.*xe32;
t59 = t12.*xe31;
t60 = t11.*xe32;
t61 = t13.*xe31;
t62 = t4.*xi1;
t63 = t5.*xi1;
t64 = t6.*xi1;
t65 = t7.*xi1;
t66 = t14.*xe42;
t67 = t16.*xe41;
t68 = t15.*xe42;
t69 = t17.*xe41;
t70 = t8.*xi2;
t71 = t9.*xi2;
t72 = -t26;
t73 = -t27;
t75 = -t28;
t77 = -t29;
t79 = -t30;
t81 = -t31;
t83 = -t32;
t85 = -t33;
t90 = t34+1.0;
t91 = t35+1.0;
t92 = -t3;
t93 = -t4;
t94 = -t7;
t95 = -t9;
t112 = t10.*xi1;
t113 = t11.*xi2;
t114 = t12.*xi1;
t115 = t13.*xi2;
t116 = t14.*xi1;
t117 = t15.*xi2;
t118 = t16.*xi1;
t119 = t17.*xi2;
t120 = t18.*xi1;
t121 = t19.*xi2;
t122 = t20.*xi1;
t123 = t21.*xi2;
t124 = t22.*xi1;
t125 = t23.*xi2;
t126 = t24.*xi1;
t127 = t25.*xi2;
t128 = t34-1.0;
t129 = t35-1.0;
t130 = -t38;
t131 = -t39;
t140 = t10.*t86;
t141 = t11.*t87;
t142 = t12.*t86;
t143 = t13.*t87;
t144 = t14.*t86;
t145 = t15.*t87;
t146 = t16.*t86;
t147 = t17.*t87;
t148 = t18.*t86;
t149 = t19.*t87;
t150 = t20.*t86;
t151 = t21.*t87;
t152 = t22.*t86;
t153 = t23.*t87;
t154 = t24.*t86;
t155 = t25.*t87;
t164 = t38+t39+t88+t89;
t165 = -t37+t38+t39+t88;
t166 = -t36+t38+t39+t89;
t100 = -t44;
t101 = -t46;
t105 = -t49;
t107 = -t51;
t108 = -t52;
t109 = -t53;
t110 = -t54;
t111 = -t55;
t132 = -t56;
t133 = -t58;
t134 = -t61;
t135 = -t63;
t136 = -t65;
t137 = -t66;
t138 = -t68;
t139 = -t71;
t167 = t36+t37+t130+t131;
t168 = (t36.*t37.*t128)./8.0;
t169 = (t37.*t88.*t90)./8.0;
t170 = (t36.*t37.*t129)./8.0;
t171 = (t36.*t89.*t91)./8.0;
t172 = (t36.*t89.*t128)./8.0;
t174 = (t88.*t89.*t90)./8.0;
t175 = (t37.*t88.*t129)./8.0;
t177 = (t88.*t89.*t91)./8.0;
t178 = (t88.*t164)./8.0;
t179 = (t89.*t164)./8.0;
t194 = (t36.*t166)./8.0;
t195 = (t37.*t165)./8.0;
t206 = (t88.*t165)./8.0;
t207 = (t89.*t166)./8.0;
t214 = t75+t116+t117+t140+t149+xe11+xe31;
t215 = t77+t118+t119+t142+t151+xe12+xe32;
t216 = t72+t112+t113+t144+t153+xe21+xe41;
t217 = t73+t114+t115+t146+t155+xe22+xe42;
t218 = t83+t124+t125+t141+t148+xe11+xe31;
t219 = t85+t126+t127+t143+t150+xe12+xe32;
t220 = t79+t120+t121+t145+t152+xe21+xe41;
t221 = t81+t122+t123+t147+t154+xe22+xe42;
t156 = t40+t100;
t157 = t42+t101;
t158 = t41+t109;
t159 = t45+t105;
t160 = t43+t111;
t161 = t47+t107;
t162 = t48+t108;
t163 = t50+t110;
t208 = (t36.*t167)./8.0;
t209 = (t37.*t167)./8.0;
t222 = (t36.*t214)./1.6e+1;
t223 = (t36.*t215)./1.6e+1;
t224 = (t37.*t218)./1.6e+1;
t225 = (t37.*t219)./1.6e+1;
t226 = (t36.*t220)./1.6e+1;
t227 = (t37.*t220)./1.6e+1;
t228 = (t36.*t221)./1.6e+1;
t229 = (t37.*t221)./1.6e+1;
t230 = t177+t178;
t231 = t174+t179;
t232 = (t89.*t214)./1.6e+1;
t233 = (t89.*t215)./1.6e+1;
t234 = (t88.*t216)./1.6e+1;
t235 = (t89.*t216)./1.6e+1;
t236 = (t88.*t217)./1.6e+1;
t237 = (t89.*t217)./1.6e+1;
t238 = (t88.*t218)./1.6e+1;
t239 = (t88.*t219)./1.6e+1;
t240 = t171+t194;
t241 = t169+t195;
t242 = t175+t206;
t243 = t172+t207;
t262 = t2+t5+t6+t8+t57+t59+t60+t62+t64+t67+t69+t70+t92+t93+t94+t95+t132+t133+t134+t135+t136+t137+t138+t139;
t180 = (t36.*t37.*t159)./1.6e+1;
t181 = (t36.*t37.*t161)./1.6e+1;
t182 = (t36.*t37.*t162)./1.6e+1;
t183 = (t36.*t37.*t163)./1.6e+1;
t184 = (t36.*t89.*t156)./1.6e+1;
t185 = (t36.*t89.*t157)./1.6e+1;
t186 = (t37.*t88.*t158)./1.6e+1;
t187 = (t36.*t89.*t159)./1.6e+1;
t189 = (t37.*t88.*t160)./1.6e+1;
t190 = (t36.*t89.*t161)./1.6e+1;
t192 = (t37.*t88.*t162)./1.6e+1;
t193 = (t37.*t88.*t163)./1.6e+1;
t196 = (t88.*t89.*t156)./1.6e+1;
t198 = (t88.*t89.*t157)./1.6e+1;
t200 = (t88.*t89.*t158)./1.6e+1;
t202 = (t88.*t89.*t160)./1.6e+1;
t263 = 1.0./t262;
t246 = t182+t227;
t247 = t183+t229;
t248 = t187+t222;
t249 = t190+t223;
t256 = t196+t235;
t257 = t198+t237;
t258 = t200+t234;
t259 = t202+t236;
mt1 = [t230.*t263.*(t13-t17+t21-t25+t84-xe12+xe22+xe32).*2.0-t231.*t263.*(t12-t16+t20-t24+t76-xe12+xe32+xe42).*2.0,t258.*t263.*(t13-t17+t21-t25+t84-xe12+xe22+xe32).*-2.0+t256.*t263.*(t12-t16+t20-t24+t76-xe12+xe32+xe42).*2.0,t259.*t263.*(t13-t17+t21-t25+t84-xe12+xe22+xe32).*-2.0+t257.*t263.*(t12-t16+t20-t24+t76-xe12+xe32+xe42).*2.0,t240.*t263.*(t13-t17+t21-t25+t84-xe12+xe22+xe32).*-2.0+t243.*t263.*(t12-t16+t20-t24+t76-xe12+xe32+xe42).*2.0];
mt2 = [t248.*t263.*(t13-t17+t21-t25+t84-xe12+xe22+xe32).*2.0+t263.*(t184-t232).*(t12-t16+t20-t24+t76-xe12+xe32+xe42).*2.0,t249.*t263.*(t13-t17+t21-t25+t84-xe12+xe22+xe32).*2.0+t263.*(t185-t233).*(t12-t16+t20-t24+t76-xe12+xe32+xe42).*2.0,t263.*(t170-t208).*(t13-t17+t21-t25+t84-xe12+xe22+xe32).*2.0-t263.*(t168-t209).*(t12-t16+t20-t24+t76-xe12+xe32+xe42).*2.0];
mt3 = [t246.*t263.*(t12-t16+t20-t24+t76-xe12+xe32+xe42).*2.0+t263.*(t180-t226).*(t13-t17+t21-t25+t84-xe12+xe22+xe32).*2.0,t247.*t263.*(t12-t16+t20-t24+t76-xe12+xe32+xe42).*2.0+t263.*(t181-t228).*(t13-t17+t21-t25+t84-xe12+xe22+xe32).*2.0,t242.*t263.*(t13-t17+t21-t25+t84-xe12+xe22+xe32).*-2.0+t241.*t263.*(t12-t16+t20-t24+t76-xe12+xe32+xe42).*2.0];
mt4 = [t263.*(t192-t224).*(t12-t16+t20-t24+t76-xe12+xe32+xe42).*2.0-t263.*(t186-t238).*(t13-t17+t21-t25+t84-xe12+xe22+xe32).*2.0,t263.*(t193-t225).*(t12-t16+t20-t24+t76-xe12+xe32+xe42).*2.0-t263.*(t189-t239).*(t13-t17+t21-t25+t84-xe12+xe22+xe32).*2.0,t230.*t263.*(t11-t15+t19-t23+t82-xe11+xe21+xe31).*-2.0+t231.*t263.*(t10-t14+t18-t22+t74-xe11+xe31+xe41).*2.0];
mt5 = [t258.*t263.*(t11-t15+t19-t23+t82-xe11+xe21+xe31).*2.0-t256.*t263.*(t10-t14+t18-t22+t74-xe11+xe31+xe41).*2.0,t259.*t263.*(t11-t15+t19-t23+t82-xe11+xe21+xe31).*2.0-t257.*t263.*(t10-t14+t18-t22+t74-xe11+xe31+xe41).*2.0,t240.*t263.*(t11-t15+t19-t23+t82-xe11+xe21+xe31).*2.0-t243.*t263.*(t10-t14+t18-t22+t74-xe11+xe31+xe41).*2.0,t248.*t263.*(t11-t15+t19-t23+t82-xe11+xe21+xe31).*-2.0-t263.*(t184-t232).*(t10-t14+t18-t22+t74-xe11+xe31+xe41).*2.0];
mt6 = [t249.*t263.*(t11-t15+t19-t23+t82-xe11+xe21+xe31).*-2.0-t263.*(t185-t233).*(t10-t14+t18-t22+t74-xe11+xe31+xe41).*2.0,t263.*(t170-t208).*(t11-t15+t19-t23+t82-xe11+xe21+xe31).*-2.0+t263.*(t168-t209).*(t10-t14+t18-t22+t74-xe11+xe31+xe41).*2.0,t246.*t263.*(t10-t14+t18-t22+t74-xe11+xe31+xe41).*-2.0-t263.*(t180-t226).*(t11-t15+t19-t23+t82-xe11+xe21+xe31).*2.0];
mt7 = [t247.*t263.*(t10-t14+t18-t22+t74-xe11+xe31+xe41).*-2.0-t263.*(t181-t228).*(t11-t15+t19-t23+t82-xe11+xe21+xe31).*2.0,t242.*t263.*(t11-t15+t19-t23+t82-xe11+xe21+xe31).*2.0-t241.*t263.*(t10-t14+t18-t22+t74-xe11+xe31+xe41).*2.0,t263.*(t192-t224).*(t10-t14+t18-t22+t74-xe11+xe31+xe41).*-2.0+t263.*(t186-t238).*(t11-t15+t19-t23+t82-xe11+xe21+xe31).*2.0];
mt8 = [t263.*(t193-t225).*(t10-t14+t18-t22+t74-xe11+xe31+xe41).*-2.0+t263.*(t189-t239).*(t11-t15+t19-t23+t82-xe11+xe21+xe31).*2.0];
B = reshape([mt1,mt2,mt3,mt4,mt5,mt6,mt7,mt8],12,2);
end
