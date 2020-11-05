# frozen_string_literal: true

module Tld
  COMMON = %w[
    com org net biz me
    uk us au ca nz my io to
    edu gov xxx ca co.uk com.au
  ].freeze

  INTERNATIONAL = %w[
    ac ad ae af ag ai al am ao aq ar as at aw ax az ba bb bd be bf bg bh bi bj bm bn bo br bs
    bt bw by bz cc cd cf cg ch ci ck cl cm cn co cr cu cv cw cx cy cz de dj dk dm do dz ec ee
    eg er es et eu fi fj fk fm fo fr ga gd ge gf gg gh gi gl gm gn gp gq gr gs gt gu gw gy hk
    hm hn hr ht hu id ie il im in iq ir is it je jm jo jp ke kg kh ki km kn kp kr kw ky kz la
    lb lc li lk lr ls lt lu lv ly ma mc md me mg mh mk ml mm mn mo mp mq mr ms mt mu mv mw mx
    mz na nc ne nf ng ni nl no np nr nu om pa pe pf pg ph pk pl pm pn pr ps pt pw py qa re ro
    rs ru rw sa sb sc sd se sg sh si sk sl sm sn so sr ss st su sv sx sy sz tc td tf tg th tj
    tk tl tm tn tr tt tv tw tz ua ug uy uz va vc ve vg vi vn vu wf ws ye yt za zm zw
  ].freeze

  ALL = Set.new(COMMON + INTERNATIONAL)
end
