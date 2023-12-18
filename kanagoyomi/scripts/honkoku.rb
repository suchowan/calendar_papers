# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014-2023 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in https://github.com/suchowan/when_exe.
=end

if __FILE__ == $0
  require 'pp'
  require 'when_exe'
end

#
# 江戸時代の仮名暦
#
module When::CalendarNote::Japanese::Kanagoyomi

  autoload :H土用日時,       './note_data'
  autoload :H二十四節気日時, './note_data'

  include When
  include When::CalendarNote::Japanese::Index

  H十干 = {
    '甲' => 'きのえ',   '乙' => 'きのとの',   '丙' => 'ひのえ', '丁' => 'ひのとの',
    '戊' => 'つちのえ', '己' => 'つちのとの', '庚' => 'かのえ', '辛' => 'かのとの',
    '壬' => 'みつのえ', '癸' => 'みつのとの'
  }

  H十二支 = {
    '子' => 'ね',   '丑' => 'うし', '寅' => 'とら', '卯' => 'う',
    '辰' => 'たつ', '巳' => 'み',   '午' => 'むま', '未' => 'ひつし',
    '申' => 'さる', '酉' => 'とり', '戌' => 'いぬ', '亥' => 'い'
  }

  H漢数字 = {
     0 => ''  , 1 => '一',  2 => '二',  3 => '三',
     4 => '四', 5 => '五',  6 => '六',  7 => '七',
     8 => '八', 9 => '九', 10 => '十', 20 => '廿',
    30 => '卅'
  }

  #
  # 年の暦注
  #
  class C年

    include When::CalendarNote::Japanese::Kanagoyomi

    H暦法 = {
      '宣明暦'     => '暦',            '貞享乙丑暦' => '貞享暦',
      '貞享暦'     => '貞享暦',        '宝暦癸酉暦' => '貞享暦',
      '宝暦甲戌暦' => '貞享暦',        1755 => '新暦', 1756=>'暦',
      '宝暦暦'     => '宝暦甲戌元暦',  '修正宝暦暦' => '宝暦甲戌元暦',
      '寛政暦'     => '寛政暦',        '寛政丁亥暦' => '寛政暦',
      '天保暦'     => '天保壬寅元暦'
    }

    H前書  = {
      1685 => "貞観以降用宣明暦既及数百年推歩与天差方今停旧暦頒新暦於天下因改正而刊行焉<br/>"+
              "貞享元年きのえ祢十二月大卅日せつふん",

      1686 => "貞享元年止旧暦用新暦十二月二十九日<br/>"+
              "詔賜名曰貞享暦",

      1729 => "<ul><li>来酉の年の板行暦の終に年の節と中とは、暦中第一の要所にて、耕作種蒔、或草木鳥獣にいたるまで節季を違ふべからず、"+
              "然るに暦の下段の内<small>江</small>、入交りて見へわかちがたし、廿四季の名并時剋を別段に挙志るし、暦を開くに早速見へ安からしむ、"+
              "また昼夜の数は古の暦に記せりといへども、中葉より断絶せり。是又民間に志らしめんため、旧例に志たがひ、書入るゝ者也<br/></li></ul>"+
              "　　　<ruby><rb>申八月</rb><rt>（享保十三年）</rt></ruby>"+
              "<div align='right'>渋川六蔵源則休　　　　&nbsp;<br/>猪飼豊次郎源久一　　&nbsp;<br/>謹推数考定　&nbsp;</div>",

      1740 => "世俗一昼夜を云ハ明ケ六時を一日ノ初とし次の明ケ六時迄を終りとす、月食を志るす事も俗習に志たがひ右の通り用来れり、"+
              "然とも元より子丑寅卯の四時ハ次の日の処分なる故今より後此四時にハ翌の字を附てこれを知しむ<br/>"+
              "　并二十四節土用も皆右のことし自今以後此例に志たかふなり重而断るにおよはす<br/>"+
              "<div align='right'>渋川六蔵源則休　　　　&nbsp;<br/>謹誌&nbsp;<br/>猪飼豊次郎源久一　　&nbsp;</div>",

      1755 => "　貞享以降距数十年用一暦其推歩与天差矣今立表測景定気朔而治新暦以頒之於天下"+
              "<ul><li>　暦面にいむ日は多しといへども吉日は天しや大みやうの二ツのみにて世俗の日取足りかたかるへし"+
                      "仍て今天恩母倉月徳三ツの吉日を記して知しむるものなり</li>"+
                  "<li>　彼岸の中日ハ昼夜等分にして天地の気均しき時なり前暦の注する所是に違へり"+
                      "故ニ今よりその誤を糺し仍て是を附出す仍て前暦の彼岸と春ハ七日進ミ秋ハ三日すゝむもの也</li>"+
                  "<li>　昼夜を分ツこと世俗の時取惑多し仍て一たひ翌の字を附出すといへともなを其のまとひ解かたし"+
                      "故ニ夜半より前を今夜と記し夜半より後を今暁と記すもの也</li></ul>"+
              "<div align='right'>土御門　　　　　従三位陰陽頭安倍泰邦<br/>"+
              "<ruby><rb>門人　天文生源光洪</rb><rt>　　　　　渋川図書　　　　　</rt></ruby></div>",

      1756 => "宝暦四年止旧暦用新暦十月十九日<br/>"+
              "詔賜名曰宝暦甲戌元暦<br/>"+
              "　去年新暦面に記し出す所の三ケ条自今永く用て異る事なし重て断り示に及ハす<br/>"+
              "<div align='right'>土御門三位泰邦　　　　<br/>門人渋川図書光洪</div>",

      1767 => "今まて頒行ふ所の暦日月食三分以下はしるし来らす此たひ<br/>"+
              "命ありて浅食といへともこと〱く記さしむ志かれとも新暦しらへいまたおはらすよりて今まての数にならふのミ",

      1771 => "宝暦の新暦しらへなり<br/>"+
              "命をうけたまはりことしより後はしらへたる<br/>"+
              "法数を用て頒ち行ふものなり",

      1798 => "順天審象定作新暦<br/>"+
              "依例頒行四方遵用",

      1799 => "寛政九年新暦成<br/>"+
              "十月<br/>"+
              "進奏<br/>"+
              "賜名寛政暦",

      1844 => "今まて頒ち行れし寛政暦ハ違える事のあるをもて更に改暦の<br/>"+
              "命あり遂に天保十三年新暦成に及ひ<br/>"+
              "詔して名を天保壬寅元暦と賜ふ<br/>"+
              "抑元文五年庚申宝暦五年乙亥の暦にことわる如く一昼夜を云ハ今暁九時を始とし今夜九時を終とす"+
              "然れとも是まて頒ち行れし暦には毎月節気中気土用日月食の時刻をいふもの皆昼夜を平等して記すか故其時刻時の鐘とまゝ遅速の違あり"+
              "今改る所ハ四時日夜の長短に随ひ其時を量り記し世俗に違ふ事なからしむ今より後此例に従ふ"
    }

    H暦首 = {
      1685 => '貞享二年きのとのうし乃暦凡三百五十四ケ日',

      1686 => '貞享三年ひのえとら乃暦凡三百八十二二ケ日　貞享暦',
    }

    H年号年次 = {
      ['天和', '二'] => ['延宝', '十'  ],
      ['弘化', '元'] => ['天保', '十五'],
      ['弘化', '二'] => ['天保', '十六'],
      ['安政', '二'] => ['嘉永', '八']
    }

    H暦注 = {
      Y干支   => false, # ひらがな
      Y廿八宿 => false, # ～値年
      Y大歳   => '大さい',
      Y大將軍 => '大しやうくん',
      Y大陰   => '大おん',
      Y歳徳   => 'としとく',
      Y歳刑   => 'さいけう',
      Y歳破   => 'さいは',
      Y歳煞   => 'さいせつ',
      Y黄幡   => 'わうはん',
      Y豹尾   => 'へうひ',
      Y金神   => false,
      Y大小   => false  # 各月大小凡～日
    }

    A暦注   = H暦注.keys.sort

    H大將軍 = {
      '子' => '辰',  '卯' => '未', '午' => '戌',  '酉' => '丑'
    }

    H歳徳神 = {
      '東宮甲' => 'とらう', '西宮庚' => 'さるとり', '南宮丙' => 'みむま', '北宮壬' => 'いね'
    }

    H金神 = {
      '午未申酉'     => 'むまひつし さるとり',
      '辰巳'         => 'たつ み',
      '子丑寅卯午未' => 'ねうしとら うむまひつし',
      '寅卯戌亥'     => 'とらう いぬい',
      '子丑申酉'     => 'ねうし さるとり',
    }

    def initialize(暦年)
      @暦年 = 暦年
      @西暦 = 暦年.most_significant_coordinate
      @年号 = 暦年.calendar_era_name
      @年次 = 漢数字(暦年[YEAR], '元')
      @年号, @年次 = H年号年次[[@年号, @年次]] || [@年号, @年次]
      @暦法 = H暦法[@西暦] || H暦法[CalendarNote('Japanese').send(:_to_date_for_note, 暦年).cal4note.l_calendar.iri.split('::').last]
      @暦注 = 暦年.notes(:indices=>YEAR, :notes=>H暦注集合).simplify
      @干支 = y干支.to_s
      @干支 = H十干[@干支[0..0]] + H十二支[@干支[1..1]]
      @宿   = y廿八宿.to_s.sub(/\(.+\z/,'')
      @日数 = y大小.to_s
      @大小 = []
      @日数.scan(/(大|小)(閏(大|小))?/) do |月|
        書式  = '%s月'   + 月[0]
        書式 += '<br/>閏%s月' + 月[2] if 月[2]
        @大小 << 書式
      end
      @日数 =~ /\((\d+)\)/
      @日数 = 漢数字($1.to_i)
    end

    def 納音欄連結可?
      false
    end

    def 暦注生成
      # 出版元
      出力   = ('<版元/><tr><td colspan=2 align=center><big><b>出版地○○</b></big></td>' +                   # 京都
                    '<td colspan=4><big><b>出版元□□□</b></big></td><td colspan=2>&nbsp;</td></tr>') # 大經師降屋内匠

      # 前書
      出力 += "<前書/><tr><td colspan=8><big><b>#{H前書[@西暦]}</b></big></td></tr>" if H前書[@西暦]

      # 暦首
      if H暦首[@西暦]
        出力 += "<暦首/><tr><td colspan=8><big><b>%s</b></big></td></tr>" % H暦首[@西暦]
      elsif @西暦 >= 1685
        出力 += ('<暦首/><tr><td colspan=5><big><b>%s%s年%s乃%s</b></big></td><td>%s<br/>値年</td>' +
                     '<td colspan=2><big><b>凡%s日</b></big></td></tr>') %
                  [@年号, @年次, @干支, @暦法, @宿, @日数]
      else
        出力 += ('<暦首/><tr><td colspan=5><big><b>%s%s年%s乃%s</b></big></td>' +
                     '<td colspan=3><big><b>凡%sヶ日</b></big></td></tr>') %
                  [@年号, @年次, @干支, @暦法, @日数]
      end

      # 大歳
      出力 += ('<大歳/><tr><td colspan=3><big><b>大さい%sの方</b></big></td>' +
                   '<td colspan=2>此方ニむかひて万よし<br/>但木をきらす</td>DIRECTION_MAP</tr>') %
              [H十二支[y大歳[1].to_s[-5..-5]]]

      # 大將軍
      暦注 = y大將軍[1].to_s
      出力 += ('<大將軍/><tr><td colspan=3><big><b>大しやうくん%sの方</b></big></td>' +
                   '<td colspan=2>%sのとしまて<br/>三年ふさかり</td></tr>') %
              [H十二支[暦注], H十二支[H大將軍[暦注]]]

      # 大陰
      出力 += ('<大陰/><tr><td colspan=3><big><b>大おん%sの方</b></big></td>' +
                   '<td colspan=2>此方ニむかひて<br/>さんをせす</td></tr>') %
              [H十二支[y大陰[1].to_s]]

      # 歳徳
      出力 += ('<歳徳/><tr><td>&nbsp;</td><td colspan=3><big><b>としとくあきの方<br/>%sの間万よし</b></big></td>') %
              [H歳徳神[y歳徳[1].to_s]]

      # 金神
      出力 += ('<td>%s</td></tr>') % [H金神[y金神[1].to_s].sub(' ', '<br/><big><b>金神</b></big><br/>')]

      # 歳刑
      出力 += ('<歳刑/><tr><td colspan=3><big><b>さいけう%sの方</b></big></td>' +
                   '<td colspan=2>むかひて<br/>たねまかす</td>') %
              [H十二支[y歳刑[1].to_s]]

      # 土公
      if @西暦 >= 1685
        出力 += ('<td><big><b>土公</b></big></td>' +
                 '<td>春はかま<br/>秋は井</td>' +
                 '<td>夏はかと<br/>冬はには</td></tr>')
      else
        出力 += '</tr>'
      end

      # 歳破
      出力 += ('<歳破/><tr><td colspan=3><big><b>さいは%sの方</b></big></td>' +
                   '<td colspan=2>むかひてわたましせす<br/>ふねのりはしめす</td>') %
              [H十二支[y歳破[1].to_s]]

      # 大小(正～三)
      (1..3).each do |月番号|
        出力 += "<td><big><b>#{@大小[月番号-1]}</b></big></td>" %  ([漢数字(月番号,'正')]*2)
      end
      出力 += '</tr>'

      # 歳煞 
      出力 += ('<歳煞/><tr><td colspan=3><big><b>さいせつ%sの方</b></big></td>' +
                   '<td colspan=2>此方より<br/>よめとらす</td>') %
              [H十二支[y歳煞[1].to_s]]

      # 大小(四～六)
      (4..6).each do |月番号|
        出力 += "<td><big><b>#{@大小[月番号-1]}</b></big></td>" %  ([漢数字(月番号,'正')]*2)
      end
      出力 += '</tr>'

      # 黄幡
      出力 += ('<黄幡/><tr><td colspan=3><big><b>わうはん%sの方</b></big></td>' +
                   '<td colspan=2>むかひて<br/>弓はしめよし</td>') %
              [H十二支[y黄幡[1].to_s]]

      # 大小(七～九)
      (7..9).each do |月番号|
        出力 += "<td><big><b>#{@大小[月番号-1]}</b></big></td>" %  ([漢数字(月番号,'正')]*2)
      end
      出力 += '</tr>'

      # 豹尾
      出力 += ('<豹尾/><tr><td colspan=3><big><b>へうひ%sの方</b></big></td>' +
                   '<td colspan=2>むかひて大小へんせす<br/>ちくるいもとめす</td>') %
              [H十二支[y豹尾[1].to_s]]

      # 大小(十～十二)
      (10..12).each do |月番号|
        出力 += "<td><big><b>#{@大小[月番号-1]}</b></big></td>" %  ([漢数字(月番号,'正')]*2)
      end
      出力 += '</tr>'

      # 暦序
      出力
    end

    def 暦末生成
      作成年     = @暦年.floor(MONTH) - P1M * 3
      年号       = 作成年.calendar_era_name
      年次       = 漢数字(作成年[YEAR], '元')
      年号, 年次 = H年号年次[[年号, 年次]] || [年号, 年次]
      '<暦末/><tr><td colspan=4 align=center><big><b>%s%s年出</b></big></td><td colspan=4 align=center><big><b>%s</b></big></td></tr>' %
      [年号, 年次 , '立表測景定節氣者']
    end
  end

  #
  # 月の暦注
  #
  class C月

    include When::CalendarNote::Japanese::Kanagoyomi

    H暦注 = {
      M廿八宿 => false, # ～値月
      M月建   => false, # 漢字
      M大小   => false
    }

    A暦注   = H暦注.keys.sort

    A土公   = %w(かま かと 井 にハ)

    A書式 =
      ['<tr><td align=center><big><b>%s</b></big></td><td align=center><big><b>%s</b></big></td>' +
           '<td align=right><big><b>建</b></big></td><td colspan=2 align=center><big><b>%s</b></big></td>' +
           '<td colspan=3><big><b>%s値月%s%s値朔日</b></big></td></tr>',
       '<tr><td align=center><big><b>%s</b></big></td><td align=center><big><b>%s</b></big></td>' +
           '<td align=right><big><b>建</b></big></td><td colspan=2 align=center><big><b>%s</b></big></td>' +
           '<td colspan=3><big><b>%s　%s　%s</b></big></td></tr>',
       '<tr><td align=center><big><b>%s</b></big></td><td align=center><big><b>%s</b></big></td>' +
           '<td colspan=4 align=center><big><b>%s</b></big></td>' +
           '<td colspan=2><big><b>%s%s　%s</b></big></td></tr>',
       "<tr><td align=center><big><b>%s</b></big></td><td align=center bgcolor='Black'><big><b><font color='White'>%s</font></b></big></td>" +
           "<td align=center><big><b>%s%s</b></big></td><td align=center bgcolor='Black'><big><b><font color='White'>%s</font></b></big></td>" +
           "<td colspan=4><big><b>とこう%s</b></big><small>ニ</small><big><b>あり</b></big></td></tr>"]

    def initialize(暦日, 朔)
      @暦日   = 暦日
      @西暦   = 暦日.most_significant_coordinate
      @暦注   = 暦日.notes(:indices=>MONTH, :notes=>H暦注集合).simplify
      @干支   = m月建[1].to_s.sub(/\(.+\z/, '')
      @宿     = m廿八宿.to_s.sub(/\(.+\z/, '')
      @月番号 = (暦日[MONTH]*0==1 ? '閏' : '') + 漢数字(暦日[MONTH]*1, '正') + '月'
      @日数   = m大小.to_s =~ /30/ ? '大' : '小'
      @朔宿   = 朔.宿
      @七曜   = 朔.七曜
      if @西暦 < 1685
        @書式 = A書式[3]
      elsif @暦日[MONTH]*0 == 1
        @書式 = A書式[2]
        @干支 = 暦日.most_significant_coordinate >= 1697 ? '隨節用之' : ''
        @宿 = ''
        @朔宿 = @朔宿.sub('宿', '')
        @七曜 = @七曜.sub('曜', 'よう')
      elsif @暦日[MONTH]*1 == 1
        @書式 = A書式[0]
      else
        @書式 = A書式[1]
        @朔宿 = @朔宿.sub('宿', '')
        @七曜 = @七曜.sub('曜', 'よう')
      end
      @書式 = 'FULL_MONTH<月序/>' + @書式
    end

    def 納音欄連結可?
      false
    end

    def 暦注生成
      if @西暦 >= 1685
        @書式 % [@月番号, @日数, @干支, @宿, @朔宿, @七曜]
      else
        @書式 % [@朔宿, @干支[0..0], @月番号, @日数, @干支[1..1], A土公[(@暦日[MONTH]*1 - 1) / 3]]
      end
    end
  end

  #
  # 日の暦注
  #
  class C日

    include When::CalendarNote::Japanese::Kanagoyomi

    H暦注 = {
      D干支     => false, # ひらがな
      D納音     => false, # 二日ごとにまとめて
      D十二直   => false, # ひらがな
      D七曜     => false, # 朔のみ月序に
      D廿七宿   => false, # 朔のみ月序に,'きしくは当日に',
      D廿八宿   => false, # 朔のみ月序に,'きしくは当日に',
      D廿四節気 => false, # 時刻、日の出より日の入りまで、六より六まで
      D節中     => false,
      D節分     => 'せつふん',
      D八十八夜 => '八十八や',
      D入梅     => false,
      D半夏生   => 'はんけしやう',
      D二百十日 => false,
      D二百廿日 => false,
      D八專     => false, # 八せんのはじめ、八せんのおはり
      D八專間日 => false, # ま日
      D天一     => '天一天上',
      D社       => '社日',
      D彼岸     => 'ひかん<small>ニ</small>なる',
      D三伏     => false,
      D土用事   => false,
      D十方暮   => '十方くれ<small>ニ</small>入',
      D受死     => '●',
      D十死     => '十し',
      D天赦     => '天しや よろつよし',
      D歳下食   => 'さい下しき',
      D神吉     => '神よし',
      D鬼宿     => 'きしく',
      D甘露     => 'かんろ',
      D大明     => '大みやう',
      D天恩     => '天おん',
      D母倉     => '母倉',
      D月徳     => '月とく',
      D五墓     => '五む日',
      D凶会     => 'くゑ日',
      D歸忌     => 'きこ',
      D血忌     => 'ちいみ',
      D大禍     => '大くわ',
      D重       => 'ちう日',
      D復       => 'ふく日',
      D滅門     => 'めつもん',
      D天火     => '天火',
      D地火     => '地火',
      D狼藉     => 'らうしやく',
      D往亡     => 'わうまう',
      D下食時   => false,
      D金性     => '金性の人うけ<small>ニ</small>入',
      D小字注   => false,
      D除手足甲 => false
    }

    A暦注 = H暦注.keys.sort
    A上段 = [D干支, D納音,     D十二直, D七曜,   D廿八宿,   D廿四節気, D節中]
    A中段 = [D節分, D八十八夜, D入梅,   D半夏生, D二百十日, D二百廿日, D天一, D彼岸, D社, D三伏, D土用事, D八專, D八專間日, D十方暮]
    A下段 = A暦注 - (A上段 + A中段) - [D廿七宿]

    A宣明上段 = [D八十八夜, D二百十日, D八專, D八專間日, D天一, D社,    D三伏, D十方暮,
                 D天赦,     D鬼宿,     D大明, D母倉,     D歸忌, D血忌,  D重,   D復    ]

    A宣明中段 = [D彼岸, D土用事, D甘露, D神吉]

    A宣明下段 = A下段 - (A宣明上段 + A宣明中段)

    H十二直 = {
      '建' => 'たつ',   '除' => 'のそく', '滿' => 'みつ',   '平' => 'たいら',
      '定' => 'さたむ', '執' => 'とる',   '破' => 'やふる', '危' => 'あやふ',
      '成' => 'なる',   '收' => 'おさむ', '開' => 'ひらく', '閉' => 'とつ'
    }

    A納音書式 = ['', '<td><big><b>%s</b></big></td>', "<td valign='center' rowspan=2><big><b>%s</b></big></td>", 'BLANK_FIELD']

    H八專 = {
      '八專入' => '八せんのはしめ',
      '八專始' => '八せんのはしめ',
      '八專終' => '八せんのおはり'
    }

    H年始下段 = {
      1600..1684 => ['はかため くらひらき ひめはしめ 弓はしめよし',
                     'あきなひはしめよし'],

      1685..1686 => ['はかため くらひらき ひめはしめ 弓はしめ万よし',
                     'すきそめ 馬のりそめ かくもんはしめ あきなひはしめ万よし'],

      1687..1687 => ['はかため くらひらき ひめはしめ<br/>弓はしめ きそはしめ ふねのりはしめ万よし',
                     'すきそめ 馬のりそめ かくもんはしめ あきなひはしめ万よし'],

      1688..1696 => ['はかため くらひらき ひめはしめ<br/>弓はしめ きそはしめ ふねのりはしめ万よし',
                     'すきそめ 馬のりそめ こしのりそめ あきなひはしめ万よし'],

      1697..1872 => ['はかため くらひらき ひめはしめ きそはしめ<br/>ゆとのはしめ こしのりそめ万よし',
                     '馬のりそめ ふねのりそめ 弓はしめ<br/>あきなひはしめ すきそめ万よし']
    }

    attr_reader :暦注, :二十四節気
    attr_accessor :連結行数

    def initialize(暦日, 年始下段)
      @暦日 = 暦日
      @西暦 = 暦日.most_significant_coordinate
      @暦注 = 暦日.notes(:indices=>DAY, :notes=>H暦注集合, :shoyo=>true, :kana=>true).simplify
      @年始下段   = 年始下段
      @連結行数   = 1
      @二十四節気 = C時刻.生成(暦日, @暦注)
      @日月食記事 = 日月食記事生成
    end

    def self.年始下段(暦年)
      H年始下段.each_pair do |範囲, 暦注達|
        return 暦注達.dup if 範囲.include?(暦年)
      end
    end

    def 納音欄連結可?
      return false if @西暦 < 1685
      return false if @暦日.to_i[0] == 0                               # 干支(えと)の“と”
      return false if @暦日[MONTH] == 1 && (1..3).include?(@暦日[DAY]) # 正月三が日
      return false if @日月食記事                                      # 日月食あり
      return @二十四節気.納音欄連結可?
    end

    def 納音欄連結(前日)
      前日.連結行数 = 2
      self.連結行数 = 0 # @暦日[DAY] == 16 ? -1 : 0
    end

    def 宿
      (@西暦 >= 1685 ? d廿八宿 : d廿七宿).to_s.sub(/\(.+\z/, '')
    end

    def 七曜
      d七曜.translate('ja').sub(/日\(.+\z/, '')
    end

    def 日月食記事生成
      日月食記事 = When::CalendarNote::Japanese::Eclipse::Eclipses[@暦日.to_s[/\(.+\z/].gsub(/[()]/,'')]
      if 日月食記事
        日月食記事 = [日月食記事[0].dup, 日月食記事[1]||'']
        日月食記事[0].gsub!(/\*.*\z/,'')
      end
      日月食記事
    end

    def 暦注生成

      出力   = @暦日[DAY] == 16 ? 'HALF_MONTH' : ''
      出力  += '<tr>'

      # 上段
      #   七曜など
      if @西暦 < 1685
        if @暦日[DAY] == 1
          出力  += '<td>%s</td>' % 七曜.sub('曜', 'よう')
        else
          宣明上段暦注達 = []
          H暦注.each_pair do |項目, 値|
            暦注 = @暦注[A暦注.index(項目)]
            next unless A宣明上段.include?(項目) && !暦注.empty?
            case 項目
            when D天一     ; 宣明上段暦注達 << '天一天上' if 暦注[:value][1] == '天上始'
            when D八專     ; 宣明上段暦注達 << '八せんニ入' if H八專[暦注[:value]]
            when D八專間日 ; 宣明上段暦注達 << (@年始下段.empty? ? 'ま日' : '(ま日)')
            when D十方暮   ; 宣明上段暦注達 << '十方くれニ入' if 暦注[:value] == '十方暮始'
            when D母倉     ; 宣明上段暦注達 << 暦注[:value]
            else           ; 宣明上段暦注達 << (値 || (暦注[:value].kind_of?(Array) ? 暦注[:value][1] : 暦注[:value]))
            end
          end
          出力  += '<td>%s</td>' % 宣明上段暦注達.first
          出力.sub!('よろつよし','')
        end
      end

      #   日番号
      出力  += '<td>@<%s@></td>' % (漢数字(@暦日[DAY]) + '日')

      #   干支
      干支   = d干支.to_s
      干支   = H十干[干支[0..0]] + H十二支[干支[1..1]]
      出力  += '<td>@<%s@></td>' % 干支

      #   十二直
      出力  += '<td>@<%s@></td>' % H十二直[d十二直.to_s]

      #   日付の修飾
      if @暦日[MONTH] == 1 && @暦日[DAY] <= 3
        出力.gsub!('@<', '<big><b>')
        出力.gsub!('@>', '</b></big>')
      else
        出力.sub!('日@', '／@')
        出力.sub!('さたむ', 'さたん')
        出力.sub!('おさむ', 'おさん')
        出力.gsub!('@<', '')
        出力.gsub!('@>', '')
      end

      #   納音
      出力  += A納音書式[@連結行数] % d納音[1].to_s if @西暦 >= 1685

      # 正月の暦注
      年始下段 = @年始下段.shift if @暦注[A暦注.index(D受死)].empty? && @暦注[A暦注.index(D天赦)].empty? # 黑日でも天赦日でもない

      # 中段
      暦注達 = []
      二十四節気注 = @二十四節気.暦注生成
      暦注達 << 二十四節気注 if 二十四節気注.length > 0 && 二十四節気注 !~ /<tr/
      暦注達 << '吉事始' if /はかため/ =~ 年始下段
      H暦注.each_pair do |項目, 値|
        next unless (@西暦 >= 1685 ? A中段 : A宣明中段).include?(項目)
        if 項目 == D土用事
          土用時刻 = @二十四節気.土用時刻
          unless 土用時刻 == nil
            暦注達 << "とよう#{土用時刻}<small>ニ</small>入" if 土用時刻
            next
          end
        end
        暦注 = @暦注[A暦注.index(項目)]
        next if 暦注.empty?
        case 項目
        when D天一     ; 暦注達 << '天一天上' if 暦注[:value][1] == '天上始'
        when D土用事   ; 暦注達 << "とよう#{@二十四節気.時刻(暦注[:value])}<small>ニ</small>入"
        when D八專     ; 暦注達 << H八專[暦注[:value]] if H八專[暦注[:value]]
        when D八專間日 ; 暦注達 << (@年始下段.empty? ? 'ま日' : '(ま日)')
        when D十方暮   ; 暦注達 << '十方くれニ入' if 暦注[:value] == '十方暮始'
        else           ; 暦注達 << (値 || (暦注[:value].kind_of?(Array) ? 暦注[:value][1] : 暦注[:value]))
        end
      end
      出力  += '<td>%s</td>' % (暦注達.empty? ? '&nbsp;' : 暦注達.join('<br/>'))

      # 下段
      if 年始下段
        暦注達 = [年始下段]
        三日目 = false
      else
        暦注達 = 宣明上段暦注達 && !宣明上段暦注達.empty? ? 宣明上段暦注達[1..-1] : []
        三日目 = @暦日.cal_date[-2..-1] == [1,3]
        H暦注.each_pair do |項目, 値|
          暦注 = @暦注[A暦注.index(項目)]
          next unless (@西暦 >= 1685 ? A下段 : A宣明下段).include?(項目) && !暦注.empty?
          case 項目
          when D神吉     ; 暦注達 << 暦注[:value].sub('吉', 'よし') unless @日月食記事
          when D下食時   ; 暦注達 << "下しき#{H十二支[暦注[:value][1]]}の時"
          when D母倉     ; 暦注達 << 暦注[:value]
          when D小字注   ; 暦注達 << ['|'] << 暦注[:value] unless 三日目
          when D除手足甲 ; 暦注達 << ['|'] << 暦注[:value].sub(/除.甲/, 'つめとり') unless 三日目
          else           ; 暦注達 << (値 || (暦注[:value].kind_of?(Array) ? 暦注[:value][1] : 暦注[:value]))
          end
          break if 暦注達.last =~ /●|十し|天しや/
        end
      end
      # 年始下段注のない正月三日目は大きな字(「大みやう」には「日」までつける)で書き、吉事注は省く
      出力 += (三日目 ? '<td colspan=3><big><b>%s</b></big></td></tr>' : '<td colspan=3>%s</td></tr>') % 暦注達.join(' ')
      出力.sub!('大みやう', '大みやう日') if 三日目

      # 二十四節気
      出力 += 二十四節気注 if 二十四節気注 =~ /<tr/

      # 日月食記事
      出力 += "<食記/><tr><td colspan=4 align='center'><big><b>%s</b></big></td><td colspan=4>%s</td></tr>" % @日月食記事 if @日月食記事

       (@暦日[MONTH] == 1 && @暦日[DAY] <= 3 ? (三日目 ? '<三日/>' : '<正月/>') : "<暦日#{@連結行数}/>") + 出力
    end
  end

  #
  # 二十四節気や土用など時刻を扱う暦注
  #
  class C時刻 < C日

    include When::CalendarNote::Japanese::Kanagoyomi

    H昼夜表位置 = {
      '立春' =>  3,  '雨水' =>  4,  '啓蟄' =>  5,  '春分' =>  6,
      '清明' =>  7,  '穀雨' =>  8,  '立夏' =>  9,  '小満' => 10,
      '芒種' => 11,  '夏至' => 12,  '小暑' => 11,  '大暑' => 10,
      '立秋' =>  9,  '処暑' =>  8,  '白露' =>  7,  '秋分' =>  6,
      '寒露' =>  5,  '霜降' =>  4,  '立冬' =>  3,  '小雪' =>  2,
      '大雪' =>  1,  '冬至' =>  0,  '小寒' =>  1,  '大寒' =>  2
    }

    def self.生成(暦日, 暦注)
      クラス = 
        case 暦日.most_significant_coordinate
        when 1600...1685 ; C時刻_宣明
        when 1685...1729 ; C時刻_貞享_当初
        when 1729...1740 ; C時刻_貞享_享保14年から
        when 1740...1753 ; C時刻_貞享_元文5年から
        when 1753...1755 ; C時刻_貞享_補暦
        when 1755...1798 ; C時刻_宝暦
        when 1798...1844 ; C時刻_寛政
        else             ; C時刻_天保
        end
      クラス.new(暦日, 暦注)
    end

    def initialize(暦日, 暦注)
      @暦日 = 暦日
      @暦注 = 暦注
    end

    def 納音欄連結可?
      true
    end

    def 翌日(前日)
      false
    end

    #
    # 昼夜の時間
    #
    def 昼夜(二十四節気名)
      self.class::A昼夜[H昼夜表位置[二十四節気名]].map {|長さ|
        長さ =~ /(\d+)(\.5)?(\+)?/
        時間  = 漢数字($1.to_i) + '刻'
        時間 += '半' if $2
        時間 += '余' if $3
        時間.sub('卅','三十')
      }
    end

    #
    # 時刻の変換
    #
    def 時刻(時分秒)
      時分秒 =~ /(\d\d):(\d\d):(\d\d)/
      _時刻($1, $2, $3)
    end

    #
    # 土用の時刻
    #
    def 土用時刻
      _表引き日時(H土用日時)
    end

    #
    # 表引き日時
    #
    def _表引き日時(表)
      日付  = @暦日.to_s[/\(.+\z/].gsub(/[()]/,'')
      return 表[日付] unless 表[日付]
      時刻  = 表[日付].sub('　', '').sub(' ', '時')
      時刻 += '分' unless 時刻.sub!('0', '')
      時刻.gsub(/\d/) {|数値|
        漢数字(数値.to_i)
      }
    end
  end

  class C時刻_宣明 < C時刻         # -天和4(1684)

    A刻 = %w(ね うし とら う たつ み むま ひつし さる とり いぬ い ね)

    def 暦注生成
      節中, 入る, 二十四節気名, 時 = 二十四節気情報
      return '' unless 節中
      if 二十四節気名 =~ /寒/
        二十四節気名.sub!('寒', 'かん')
      else
        二十四節気名 = ''
      end
      '%s%s%s%s' % [二十四節気名, 節中, 時 ? 二十四節気時刻(時) : '', 入る]
    end

    def 二十四節気情報
      二十四節気 = d廿四節気
      return nil if 二十四節気.empty?
      節中 = d節中.dup
      節   = 節中.sub!('節', 'せつ')
      二十四節気.to_s =~ /\A(.+)\((.+)\/(.+)\)/
      二十四節気名 = $1
      if 節
        時   = $2.to_f * 24 / $3.to_f
        入る = '入'
      end
      [節中, 入る, 二十四節気名, 時]
    end

    #
    # 時刻の変換
    #
    def _時刻(時,分=0,秒=0)
      '%sのとき' % self.class::A刻[((時.to_i + 1) * 0.5).floor]
    end

    #
    # 二十四節気の時刻
    #
    alias :二十四節気時刻 :_時刻
  end

  class C時刻_貞享_当初 < C時刻    # 貞享2(1685)-

    A昼夜 = [
      #      貞享・宝暦    
      #   日出入     六六  
      %w(40   60   45   55 ), # 冬至
      %w(40+  59+  45+  54+), # 小寒 大雪
      %w(41+  58+  46+  53+), # 大寒 小雪
      %w(42+  57+  47+  52+), # 立春 立冬
      %w(44+  55+  49+  50+), # 雨水 霜降
      %w(47+  52+  52+  47+), # 啓蟄 寒露
      %w(50   50   55   45 ), # 春分 秋分
      %w(52+  47+  57+  42+), # 清明 白露
      %w(55+  44+  60+  39+), # 穀雨 処暑
      %w(57+  42+  62+  37+), # 立夏 立秋
      %w(58+  41+  63+  36+), # 小満 大暑 * は .0 を省略
      %w(59+  40+  64+  35+), # 芒種 小暑
      %w(60   40   65   35 )] # 夏至

    A刻 = %w(ね うし とら う たつ み むま ひつし さる とり いぬ い 夜ね)

    N丸め = 0.0

    def 暦注生成
      節中, 入る, 二十四節気名, 時, 分, 秒 = 二十四節気情報
      return '' unless 節中
      if 二十四節気名 =~ /(立|分|至|寒)/
        二十四節気名.sub!('寒', 'かん')
      else
        二十四節気名 = ''
      end
      '%s%s%s%s' % [二十四節気名, 節中, 二十四節気時刻(時, 分, 秒), 入る]
    end

    def 二十四節気情報
      二十四節気 = d廿四節気
      return nil if 二十四節気.empty?
      節中 = d節中.dup
      入る = 節中.sub!('節', 'せつ') ? '<small>ニ</small>入' : ''
      二十四節気.to_s =~ /\A(.+)\((\d+):(\d+):(\d+)\)/
      二十四節気名, 時, 分, 秒 = $~[1..4]
      [節中, 入る, 二十四節気名, 時, 分, 秒]
    end

    #
    # 時刻の変換
    #
    def _時刻(時, 分, 秒)
              端数1 = (時.to_i * 3600 + 分.to_i * 60 + 秒.to_i) / 86400.0
      刻,     端数2 = (12 * 端数1 + 0.5).divmod(1)
      小数部, 端数3 = ((100.0/12) * 端数2 + self.class::N丸め).divmod(1)
      '%sの%s刻' % [self.class::A刻[刻], (小数部==0 ? '初' : 漢数字(小数部))]
    end

    #
    # 二十四節気の時刻
    #
    alias :二十四節気時刻 :_時刻
  end

  class C時刻_貞享_享保14年から < C時刻_貞享_当初  # 享保14(1729)-
    def 納音欄連結可?
      !d廿四節気.kind_of?(String) # 二十四節気でなけれは連続可能
    end

    def 暦注生成
      節中, 入る, 二十四節気名, 時, 分, 秒 = 二十四節気情報
      return '' unless 節中
      ('<節中/><tr><td colspan=5 align=right><big><b>%s%s%s' +
       '日の出より日入まて</b></big></td><td>昼%s<br/>夜%s</td>' +
       '<td><big><b>六より六まて</b></big></td><td>昼%s<br/>夜%s</td></tr>') %
      ([二十四節気名 + 節中, 二十四節気時刻(時, 分, 秒), 入る] +  昼夜(二十四節気名))
    end
  end

  class C時刻_貞享_元文5年から < C時刻_貞享_享保14年から  # 元文5(1740)-
    A刻 = %w(翌ね 翌うし 翌とら 翌う たつ み むま ひつし さる とり いぬ い 夜ね)

    #
    # “翌”の字のつく時刻の二十四節気と土用を前日に記載するための調整処理
    #
    def 翌日(前日)
      結果 = [D廿四節気,D土用事].map { |項目| # 二十四節気, 土用
        値 = @暦注[A暦注.index(項目)][:value]
        next false unless 値.kind_of?(String) && 時刻(値.to_s) =~ /翌/
        前日.暦注[A暦注.index(項目)] = @暦注[A暦注.index(項目)]
        @暦注[A暦注.index(項目)]     = {}
        true
      }
      if 結果[0]                 # 節中
        前日.暦注[A暦注.index(D節中)] = @暦注[A暦注.index(D節中)]
        @暦注[A暦注.index(D節中)]     = {}
      end
      結果[0] || 結果[1]
    end

    #
    # 時刻の変換
    #
    def _時刻(時, 分, 秒)
      結果 = super
      結果.sub!('翌', '') if 時.to_i >= 6
      結果
    end
  end

  class C時刻_貞享_補暦 < C時刻_貞享_享保14年から  # 宝暦3(1753)-
    A刻   = %w(ね うし とら う たつ み むま ひつし さる とり いぬ い ね)

    N丸め = 0.5
  end

  class C時刻_宝暦 < C時刻_貞享_補暦   # 宝暦5(1755)-
    A刻 = %w(今暁ね 今暁うし 今暁とら う たつ み むま ひつし さる とり いぬ い 今夜ね)
  end

  class C時刻_寛政 < C時刻_宝暦   # 寛政10(1798)-

=begin
    A昼夜 = {
      '立春' => %w(四十三刻半   五十六刻半   四十八刻半余 五十一刻余),
      '雨水' => %w(四十五刻半余 五十四刻余   五十刻半余   四十九刻余),
      '啓蟄' => %w(四十八刻     五十二刻     五十三刻     四十七刻),
      '春分' => %w(五十刻余     四十九刻半余 五十五刻余   四十四刻半余),
      '清明' => %w(五十二刻半   四十七刻半   五十七刻半余 四十二刻余),
      '穀雨' => %w(五十四刻半余 四十五刻余   六十刻       四十刻),
      '立夏' => %w(五十六刻半余 四十三刻余   六十二刻余   三十七刻半余),
      '小満' => %w(五十八刻半   四十一刻半   六十四刻     三十六刻),         # 『日本の暦』
      '芒種' => %w(五十九刻半   四十刻半     六十五刻余   三十四刻半余),
      '夏至' => %w(五十九刻半余 四十刻余     六十五刻半余 三十四刻余),
      '小暑' => %w(五十九刻半   四十刻半     六十五刻余   三十四刻半余),
      '大暑' => %w(五十八刻余   四十一刻半余 六十四刻     三十六刻),         # 小満と対称でない
      '立秋' => %w(五十六刻半余 四十三刻余   六十二刻余   三十七刻半余),
      '処暑' => %w(五十四刻半余 四十五刻余   六十刻       四十刻),
      '白露' => %w(五十二刻半   四十七刻半   五十七刻半余 四十二刻余),
      '秋分' => %w(五十刻余     四十九刻半余 五十五刻余   四十四刻半余),
      '寒露' => %w(四十八刻     五十二刻     五十三刻     四十七刻),
      '霜降' => %w(四十五刻半余 五十四刻余   五十刻半余   四十九刻余),
      '立冬' => %w(四十三刻半   五十六刻半   四十八刻半余 五十一刻余),
      '小雪' => %w(四十一刻半余 五十八刻余   四十七刻余   五十二刻半余),
      '大雪' => %w(四十刻半     五十九刻半   四十六刻     五十四刻),
      '冬至' => %w(四十刻余     五十九刻半余 四十五刻半余 五十四刻余),       # 『日本の暦』と異なる(天保暦に一致)
      '小寒' => %w(四十刻半     五十九刻半   四十六刻     五十四刻),
      '大寒' => %w(四十一刻半余 五十八刻余   四十七刻余   五十二刻半余)
    }
=end

    A昼夜 = [
      #           寛政          
      #    日出入       六六    
      %w(40.5  59.5  45.5+ 54+  ), # 冬至
      %w(40.5  59.5  46    54   ), # 小寒 大雪
      %w(41.5+ 58+   47+   52.5+), # 大寒 小雪
      %w(43.5  56.5  48.5+ 51+  ), # 立春 立冬
      %w(45.5+ 54+   50.5+ 49+  ), # 雨水 霜降
      %w(48    52    53    47   ), # 啓蟄 寒露
      %w(50+   49.5+ 55+   44.5+), # 春分 秋分
      %w(52.5  47.5  57.5+ 42+  ), # 清明 白露
      %w(54.5+ 45+   60    40   ), # 穀雨 処暑
      %w(56.5+ 43+   62+   37.5+), # 立夏 立秋
      %w(58+*  41.5+ 64    36   ), # 小満 大暑 * は .0 を省略
      %w(59.5  40.5  65+   34.5+), # 芒種 小暑
      %w(59.5+ 40+   65.5+ 34+  )] # 夏至
  end

  class C時刻_天保 < C時刻_宝暦   # 天保15(1844)-
    A昼夜 = [
      #          天保
      #   日出入       六六
      %w(40+   59.5+ 45.5+ 54+  ), # 冬至
      %w(40.5  59.5  46    54   ), # 小寒 大雪
      %w(41.5+ 58+   47    53   ), # 大寒 小雪
      %w(43.5  56.5  48.5+ 51+  ), # 立春 立冬
      %w(45.5  54.5  50.5  49.5 ), # 雨水 霜降
      %w(47.5+ 52+   52.5+ 47+  ), # 啓蟄 寒露
      %w(50    50    55    45   ), # 春分 秋分
      %w(52+   47.5+ 57.5  42.5 ), # 清明 白露
      %w(54.5  45.5  59.5+ 40+  ), # 穀雨 処暑
      %w(56.5  43.5  62    38   ), # 立夏 立秋
      %w(58+   41.5+ 64    36   ), # 小満 大暑
      %w(59.5  40.5  65+   34.5+), # 芒種 小暑
      %w(59.5+ 40+   65.5+ 34+  )] # 夏至

    A時 = %w(今暁九 今暁八 今暁七 明六 朝五 朝四 昼九 昼八 夕七 暮六 夜五 夜四)

    #
    # 時刻の変換
    #
    def _時刻(時, 分, 秒)
              端数1 = (時.to_i * 3600 + 分.to_i * 60 + 秒.to_i) / 86400.0
      刻,     端数2 = (12 * 端数1).divmod(1)
      小数部, 端数3 = (10 * 端数2).divmod(1)
      return '%s時' % self.class::A時[刻] if 小数部 == 0
      '%s時%s分'    % [self.class::A時[刻], 漢数字(小数部)]
    end

    #
    # 二十四節気の時刻
    #
    def 二十四節気時刻(*引数は使用しない)
      _表引き日時(H二十四節気日時)
    end
  end

  alias :_method_missing :method_missing

  #
  # 暦注参照
  #
  def method_missing(名前, *引数達, &ブロック)
    return _method_missing(名前, *引数達, &ブロック) unless self.class.const_defined?(名前.to_s.capitalize)
    項目 = self.class.const_get(名前.to_s.capitalize)
    self.class.module_eval %Q{
      def #{名前}
        @暦注[self.class::A暦注.index(#{項目})][:value]
      end
    }
    @暦注[self.class::A暦注.index(項目)][:value]
  end

  #
  # 漢数字
  #
  def 漢数字(数値, 第一=nil)
    return 第一 if 第一 && 数値==1
    百位, 数値 = 数値.divmod(100)
    return H漢数字[百位] + '百' + 漢数字(数値)  if 百位 >  1
    return                 '百' + 漢数字(数値)  if 百位 == 1
    十位, 数値 = 数値.divmod(10)
    return H漢数字[十位] + '十' + H漢数字[数値] if 十位 >  3
    return H漢数字[十位*10]     + H漢数字[数値] if 十位 >= 1
    return H漢数字[数値]
  end

 #puts [1,9,10,11,19,20,21,29,30,31,39,40,41,88,99,100,101,111,199,200,201,210,220,365].map {|n| 漢数字(n)}

  def self.集合(暦注)
    暦注.keys.inject(0) {|集合,位置| 集合 | (1 << 位置)}
  end

  H暦注集合  = [集合(C年::H暦注), 集合(C月::H暦注), 集合(C日::H暦注)]

  #
  # 一年分の仮名暦を生成する
  #
  def 仮名暦(西暦)
    暦年     = (TemporalPosition(西暦, {:frame=>'Japanese'}) ^ CalendarEra('Japanese'))[0].floor(YEAR)
    暦注達   = [C年.new(暦年)]
    前日暦注 = nil
    年始下段 = C日.年始下段(西暦)
    暦年.year_included do |暦日|
      日の暦注 = C日.new(暦日, 年始下段)
      暦注達 << C月.new(暦日, 日の暦注)  if 暦日[DAY] == 1
      日の暦注.二十四節気.翌日(前日暦注) if 前日暦注
      日の暦注.納音欄連結(暦注達.last)   if 暦注達.last.納音欄連結可?
      暦注達  << 日の暦注
      前日暦注 = 日の暦注
    end
    出力 = 暦注達.map {|暦注| 暦注.暦注生成}.join('') + 暦注達[0].暦末生成
    <<BODY % 出力.gsub(/(<\/tr>)/, "\\1\n")
<div class="vertical">
<table border=1>
%s
</table>
</div>
BODY
  end

  alias :kanagoyomi :仮名暦
end

if __FILE__ == $0

  include When::CalendarNote::Japanese::Kanagoyomi

  if /-|,/ =~ ARGV[0]
    #
    # 範囲が指定された場合は、規定の場所に仮名暦本体を出力
    #
    ARGV[0].split(',').each do |範囲|
      最初, 最後 = 範囲.split('-')
      (最初.to_i..(最後||最初).to_i).each do |暦年|
        open("#{When::Parts::Resource.root_dir}/data/kanagoyomi/null/#{暦年}", 'w') do |出力|
          出力.puts 仮名暦(暦年)
        end
      end
    end

  else
    #
    # 特定の年が指定された場合は、標準出力に仮名暦のHTML文書を出力
    #
    puts <<HTML % 仮名暦((ARGV[0]||1843).to_i)
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8" />
<title>仮名暦</title>
<style type="text/css">
<!--
.vertical {
  writing-mode: tb-rl;
  direction: ltr;
}
-->
</style>
</head>
<body>
%s</body>
</html>
HTML
  end
end
