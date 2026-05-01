import 'package:tagly/data/tags_xml_parser.dart';

final fakeTagsResponse = TagsXmlParser.parse(fakeTagsXml);

final fakeTags = fakeTagsResponse.tags;

final fakeTag = fakeTags.first;

const fakeTagsXml = '''
<?xml version="1.0" encoding="UTF-8" ?>
<tags available="6910" count="10" stamp="2026-05-01 08:39:20">
   <tag index="1">
      <id>1482</id>
      <Title>&#039;Less You Listen</Title>
      <AltTitle>For a Heart Is Nothing</AltTitle>
      <Version>C to F Version</Version>
      <WritKey>Major:C</WritKey>
      <Parts>4</Parts>
      <Type>Barbershop</Type>
      <Recording>single part only</Recording>
      <TeachVid />
      <Lyrics>For a heart is nothing, &#039;less you listen</Lyrics>
      <Notes>This tag has a life lesson in it. It has an unexpected ending when the tenor posts. Take this one nice and easy. Now with fresher sheet music since there were lots of typos in the other. Audio takes it in Db, but sheet music is in C for easier reading (helps from keeping it going flat right?)</Notes>
      <Arranger>Paul Paddock</Arranger>
      <ArrWebsite />
      <Arranged>2011</Arranged>
      <SungBy />
      <SungWebsite />
      <SungYear />
      <Quartet>Pdpaddoc</Quartet>
      <QWebsite />
      <Teacher />
      <TWebsite />
      <Provider />
      <ProvWebsite />
      <Posted>Tue, 25 Jan 2011</Posted>
      <Classic />
      <Collection />
      <Rating>3.2024</Rating>
      <RatingCount>662</RatingCount>
      <Downloaded>19124</Downloaded>
      <stamp>2026-04-30 07:11:52</stamp>
      <SheetMusicAlt>https://www.barbershoptags.com/tags/_Less_You_Listen.png</SheetMusicAlt>
      <SheetMusic type="png">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=1482&amp;fldname=SheetMusic</SheetMusic>
      <Notation />
      <AllParts type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=1482&amp;fldname=AllParts</AllParts>
      <Bass type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=1482&amp;fldname=Bass</Bass>
      <Bari type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=1482&amp;fldname=Bari</Bari>
      <Lead type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=1482&amp;fldname=Lead</Lead>
      <Tenor type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=1482&amp;fldname=Tenor</Tenor>
      <Other1 />
      <Other2 />
      <Other3 />
      <Other4 />
      <videos available="0" count="0">
      </videos>
   </tag>
   <tag index="2">
      <id>7131</id>
      <Title>&#039;Less You Listen</Title>
      <AltTitle>For a Heart Is Nothing</AltTitle>
      <Version>Resolving Version</Version>
      <WritKey>Major:C</WritKey>
      <Parts>4</Parts>
      <Type>Other male</Type>
      <Recording>single part only</Recording>
      <TeachVid />
      <Lyrics>For a heart is nothing &#039;less you listen to it</Lyrics>
      <Notes>Starts in unison. Lower inverted notes written in for the last 2 notes on bari and bass if you&#039;re feeling bold! This one is without the unexpected ending.</Notes>
      <Arranger>Paul Paddock</Arranger>
      <ArrWebsite />
      <Arranged>2011</Arranged>
      <SungBy />
      <SungWebsite />
      <SungYear />
      <Quartet>a piano</Quartet>
      <QWebsite />
      <Teacher />
      <TWebsite />
      <Provider />
      <ProvWebsite />
      <Posted>Sun, 3 Aug 2025</Posted>
      <Classic />
      <Collection />
      <Rating>3.0823</Rating>
      <RatingCount>158</RatingCount>
      <Downloaded>616</Downloaded>
      <stamp>2026-04-29 22:03:18</stamp>
      <SheetMusicAlt>https://www.barbershoptags.com/tags/_Less_You_Listen1.png</SheetMusicAlt>
      <SheetMusic type="png">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=7131&amp;fldname=SheetMusic</SheetMusic>
      <Notation />
      <AllParts type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=7131&amp;fldname=AllParts</AllParts>
      <Bass type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=7131&amp;fldname=Bass</Bass>
      <Bari type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=7131&amp;fldname=Bari</Bari>
      <Lead type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=7131&amp;fldname=Lead</Lead>
      <Tenor type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=7131&amp;fldname=Tenor</Tenor>
      <Other1 />
      <Other2 />
      <Other3 />
      <Other4 />
      <videos available="0" count="0">
      </videos>
   </tag>
   <tag index="3">
      <id>7346</id>
      <Title>&#039;Round You</Title>
      <AltTitle />
      <Version />
      <WritKey>Major:A</WritKey>
      <Parts>4</Parts>
      <Type>Barbershop</Type>
      <Recording />
      <TeachVid />
      <Lyrics>It&#039;s very, very hard not to feel loved around, &#039;round you.</Lyrics>
      <Notes />
      <Arranger>Jake Hemmle</Arranger>
      <ArrWebsite>http://https://www.facebook.com/hayden.hemmle</ArrWebsite>
      <Arranged>2026</Arranged>
      <SungBy />
      <SungWebsite />
      <SungYear />
      <Quartet />
      <QWebsite />
      <Teacher />
      <TWebsite />
      <Provider />
      <ProvWebsite />
      <Posted>Fri, 30 Jan 2026</Posted>
      <Classic />
      <Collection />
      <Rating>3.0485</Rating>
      <RatingCount>103</RatingCount>
      <Downloaded>100</Downloaded>
      <stamp>2026-04-30 05:27:30</stamp>
      <SheetMusicAlt>https://www.barbershoptags.com/tags/_Round_You.pdf</SheetMusicAlt>
      <SheetMusic type="pdf">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=7346&amp;fldname=SheetMusic</SheetMusic>
      <Notation />
      <AllParts type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=7346&amp;fldname=AllParts</AllParts>
      <Bass />
      <Bari />
      <Lead />
      <Tenor />
      <Other1 />
      <Other2 />
      <Other3 />
      <Other4 />
      <videos available="0" count="0">
      </videos>
   </tag>
   <tag index="4">
      <id>3687</id>
      <Title>&#039;Til Him</Title>
      <AltTitle>Like You</AltTitle>
      <Version />
      <WritKey>Major:E</WritKey>
      <Parts>4</Parts>
      <Type>Barbershop</Type>
      <Recording />
      <TeachVid />
      <Lyrics>There will never, ever be another one like you. (Never ever be another one like you.)</Lyrics>
      <Notes>From Mel Brooks&#039; musical, The Producers</Notes>
      <Arranger>Jacob A. Campbell</Arranger>
      <ArrWebsite>http://cfacacappella.com</ArrWebsite>
      <Arranged>2017</Arranged>
      <SungBy />
      <SungWebsite />
      <SungYear />
      <Quartet />
      <QWebsite />
      <Teacher />
      <TWebsite />
      <Provider />
      <ProvWebsite />
      <Posted>Mon, 6 Feb 2017</Posted>
      <Classic />
      <Collection />
      <Rating>3.3333</Rating>
      <RatingCount>585</RatingCount>
      <Downloaded>1876</Downloaded>
      <stamp>2026-05-01 06:45:39</stamp>
      <SheetMusicAlt>https://www.barbershoptags.com/tags/_Til_Him.pdf</SheetMusicAlt>
      <SheetMusic type="pdf">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=3687&amp;fldname=SheetMusic</SheetMusic>
      <NotationAlt>https://www.barbershoptags.com/tags/_Til_Him.musx</NotationAlt>
      <Notation type="musx">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=3687&amp;fldname=Notation</Notation>
      <AllParts />
      <Bass />
      <Bari />
      <Lead />
      <Tenor />
      <Other1 />
      <Other2 />
      <Other3 />
      <Other4 />
      <videos available="0" count="0">
      </videos>
   </tag>
   <tag index="5">
      <id>4696</id>
      <Title>&#039;Til I Hear You Sing</Title>
      <AltTitle />
      <Version>Instant Classic extended version</Version>
      <WritKey>Major:F</WritKey>
      <Parts>4</Parts>
      <Type>Barbershop</Type>
      <Recording />
      <TeachVid />
      <Lyrics>I&#039;ll always feel no more than halfway real &#039;til I hear you sing once more.</Lyrics>
      <Notes>Note that Instant Classic does a lot of tenor/bari swapping in this tag (presumably because David can sing the bari part in &#039;not falsetto&#039;). Swap what you want as is comfortable.</Notes>
      <Arranger />
      <ArrWebsite />
      <Arranged />
      <SungBy />
      <SungWebsite />
      <SungYear />
      <Quartet />
      <QWebsite />
      <Teacher />
      <TWebsite />
      <Provider />
      <ProvWebsite />
      <Posted>Wed, 6 Nov 2019</Posted>
      <Classic />
      <Collection />
      <Rating>3.2406</Rating>
      <RatingCount>557</RatingCount>
      <Downloaded>4121</Downloaded>
      <stamp>2026-04-30 00:53:48</stamp>
      <SheetMusicAlt>https://www.barbershoptags.com/tags/_Til_I_Hear_You_Sing1.pdf</SheetMusicAlt>
      <SheetMusic type="pdf">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=4696&amp;fldname=SheetMusic</SheetMusic>
      <NotationAlt>https://www.barbershoptags.com/tags/_Til_I_Hear_You_Sing.mscz</NotationAlt>
      <Notation type="mscz">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=4696&amp;fldname=Notation</Notation>
      <AllParts type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=4696&amp;fldname=AllParts</AllParts>
      <Bass type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=4696&amp;fldname=Bass</Bass>
      <Bari type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=4696&amp;fldname=Bari</Bari>
      <Lead type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=4696&amp;fldname=Lead</Lead>
      <Tenor type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=4696&amp;fldname=Tenor</Tenor>
      <Other1 />
      <Other2 />
      <Other3 />
      <Other4 />
      <videos available="1" count="1">
         <video index="1">
            <id>1547</id>
            <Desc />
            <SungKey>Major:F</SungKey>
            <Multitrack>No</Multitrack>
            <Code>5yMeEGbca4U</Code>
            <Facebook />
            <SungBy>Ravon S</SungBy>
            <SungWebsite>http://https://www.youtube.com/user/Musikman18</SungWebsite>
            <Posted>Mon, 30 Mar 2020</Posted>
         </video>
      </videos>
   </tag>
   <tag index="6">
      <id>2915</id>
      <Title>&#039;Til I Hear You Sing</Title>
      <AltTitle />
      <Version>Sound of the Rockies version</Version>
      <WritKey />
      <Parts>4</Parts>
      <Type>Barbershop</Type>
      <Recording>part predominant - one part louder, other parts quieter</Recording>
      <TeachVid />
      <Lyrics />
      <Notes>tag to Sound of the Rockies Las Vegas 2014 International ballad.</Notes>
      <Arranger>Adam Reimnitz</Arranger>
      <ArrWebsite>http://www.adamreimnitz.com/</ArrWebsite>
      <Arranged />
      <SungBy>Sound of the Rockies</SungBy>
      <SungWebsite />
      <SungYear />
      <Quartet>Joseph Livesey</Quartet>
      <QWebsite />
      <Teacher />
      <TWebsite />
      <Provider />
      <ProvWebsite />
      <Posted>Tue, 25 Nov 2014</Posted>
      <Classic />
      <Collection />
      <Rating>3.2939</Rating>
      <RatingCount>609</RatingCount>
      <Downloaded>9415</Downloaded>
      <stamp>2026-04-30 19:38:56</stamp>
      <SheetMusicAlt>https://www.barbershoptags.com/tags/_Til_I_Hear_You_Sing.pdf</SheetMusicAlt>
      <SheetMusic type="pdf">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=2915&amp;fldname=SheetMusic</SheetMusic>
      <Notation />
      <AllParts type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=2915&amp;fldname=AllParts</AllParts>
      <Bass type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=2915&amp;fldname=Bass</Bass>
      <Bari type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=2915&amp;fldname=Bari</Bari>
      <Lead type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=2915&amp;fldname=Lead</Lead>
      <Tenor type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=2915&amp;fldname=Tenor</Tenor>
      <Other1 />
      <Other2 />
      <Other3 />
      <Other4 />
      <videos available="0" count="0">
      </videos>
   </tag>
   <tag index="7">
      <id>7078</id>
      <Title>&#039;Til I Hear You Sing</Title>
      <AltTitle />
      <Version>Instant Classic Insane Version</Version>
      <WritKey>Major:F</WritKey>
      <Parts>4</Parts>
      <Type>Barbershop</Type>
      <Recording />
      <TeachVid />
      <Lyrics>Once more! Here you sing once more, once more!</Lyrics>
      <Notes>Theo Hicks/Instant Classic tag with extension consisting of a double upwards inversion.</Notes>
      <Arranger>Ian Henning</Arranger>
      <ArrWebsite />
      <Arranged />
      <SungBy>Instant Classic</SungBy>
      <SungWebsite />
      <SungYear />
      <Quartet />
      <QWebsite />
      <Teacher />
      <TWebsite />
      <Provider />
      <ProvWebsite />
      <Posted>Thu, 26 Jun 2025</Posted>
      <Classic />
      <Collection />
      <Rating>2.9715</Rating>
      <RatingCount>246</RatingCount>
      <Downloaded>349</Downloaded>
      <stamp>2026-04-30 06:29:11</stamp>
      <SheetMusicAlt>https://www.barbershoptags.com/tags/_Til_I_Hear_You_Sing2.pdf</SheetMusicAlt>
      <SheetMusic type="pdf">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=7078&amp;fldname=SheetMusic</SheetMusic>
      <NotationAlt>https://www.barbershoptags.com/tags/_Til_I_Hear_You_Sing1.mscz</NotationAlt>
      <Notation type="mscz">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=7078&amp;fldname=Notation</Notation>
      <AllParts />
      <Bass />
      <Bari />
      <Lead />
      <Tenor />
      <Other1 />
      <Other2 />
      <Other3 />
      <Other4 />
      <videos available="0" count="0">
      </videos>
   </tag>
   <tag index="8">
      <id>6910</id>
      <Title>&#039;Til I Hear You Sing (In Bb)</Title>
      <AltTitle>Once More</AltTitle>
      <Version>Instant Classic Version</Version>
      <WritKey>Major:Bb</WritKey>
      <Parts>4</Parts>
      <Type>Barbershop</Type>
      <Recording />
      <TeachVid />
      <Lyrics>Hear you sing once more</Lyrics>
      <Notes>A keyed-down version of Instant Classic&#039;s &#039;Til I Hear You Sing</Notes>
      <Arranger>Nicholas Manning</Arranger>
      <ArrWebsite />
      <Arranged />
      <SungBy>Instant Classic</SungBy>
      <SungWebsite>http://instantclassicquartet.com</SungWebsite>
      <SungYear />
      <Quartet>The Trio</Quartet>
      <QWebsite />
      <Teacher />
      <TWebsite />
      <Provider />
      <ProvWebsite />
      <Posted>Fri, 14 Feb 2025</Posted>
      <Classic />
      <Collection />
      <Rating>3.0748</Rating>
      <RatingCount>214</RatingCount>
      <Downloaded>755</Downloaded>
      <stamp>2026-04-26 22:29:16</stamp>
      <SheetMusicAlt>https://www.barbershoptags.com/tags/_Til_I_Hear_You_Sing_(In_Bb).pdf</SheetMusicAlt>
      <SheetMusic type="pdf">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=6910&amp;fldname=SheetMusic</SheetMusic>
      <NotationAlt>https://www.barbershoptags.com/tags/_Til_I_Hear_You_Sing_(In_Bb).mscz</NotationAlt>
      <Notation type="mscz">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=6910&amp;fldname=Notation</Notation>
      <AllParts type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=6910&amp;fldname=AllParts</AllParts>
      <Bass />
      <Bari />
      <Lead />
      <Tenor />
      <Other1 />
      <Other2 />
      <Other3 />
      <Other4 />
      <videos available="0" count="0">
      </videos>
   </tag>
   <tag index="9">
      <id>1879</id>
      <Title>&#039;Til We Meet Again</Title>
      <AltTitle />
      <Version />
      <WritKey>Major:F</WritKey>
      <Parts>4</Parts>
      <Type>Barbershop</Type>
      <Recording>part predominant - one part louder, other parts quieter</Recording>
      <TeachVid />
      <Lyrics>&#039;Til We Meet Again</Lyrics>
      <Notes />
      <Arranger>Bobby Gray, Jr.</Arranger>
      <ArrWebsite />
      <Arranged />
      <SungBy />
      <SungWebsite />
      <SungYear />
      <Quartet>Joseph Livesey</Quartet>
      <QWebsite />
      <Teacher />
      <TWebsite />
      <Provider />
      <ProvWebsite />
      <Posted>Mon, 5 Mar 2012</Posted>
      <Classic />
      <Collection />
      <Rating>3.4076</Rating>
      <RatingCount>655</RatingCount>
      <Downloaded>10650</Downloaded>
      <stamp>2026-04-28 09:19:03</stamp>
      <SheetMusicAlt>https://www.barbershoptags.com/tags/__Til_We_Meet_Again.jpg</SheetMusicAlt>
      <SheetMusic type="jpg">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=1879&amp;fldname=SheetMusic</SheetMusic>
      <Notation />
      <AllParts type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=1879&amp;fldname=AllParts</AllParts>
      <Bass type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=1879&amp;fldname=Bass</Bass>
      <Bari type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=1879&amp;fldname=Bari</Bari>
      <Lead type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=1879&amp;fldname=Lead</Lead>
      <Tenor type="mp3">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=1879&amp;fldname=Tenor</Tenor>
      <Other1 />
      <Other2 />
      <Other3 />
      <Other4 />
      <videos available="0" count="0">
      </videos>
   </tag>
   <tag index="10">
      <id>4952</id>
      <Title>&#039;Til We Meet Again</Title>
      <AltTitle />
      <Version />
      <WritKey>Major:G</WritKey>
      <Parts>4</Parts>
      <Type>Barbershop</Type>
      <Recording />
      <TeachVid />
      <Lyrics>But who knows where or when? The day will come my friend, &#039;til we meet again.</Lyrics>
      <Notes />
      <Arranger>Mitchell Bartel</Arranger>
      <ArrWebsite>http://mitchellbartel.com</ArrWebsite>
      <Arranged>2020</Arranged>
      <SungBy />
      <SungWebsite />
      <SungYear />
      <Quartet />
      <QWebsite />
      <Teacher />
      <TWebsite />
      <Provider />
      <ProvWebsite />
      <Posted>Mon, 28 Sep 2020</Posted>
      <Classic />
      <Collection />
      <Rating>3.2585</Rating>
      <RatingCount>472</RatingCount>
      <Downloaded>821</Downloaded>
      <stamp>2026-04-26 23:38:09</stamp>
      <SheetMusicAlt>https://www.barbershoptags.com/tags/_Til_We_Meet_Again.pdf</SheetMusicAlt>
      <SheetMusic type="pdf">https://www.barbershoptags.com/dbaction.php?action=DownloadFile&amp;dbase=tags&amp;id=4952&amp;fldname=SheetMusic</SheetMusic>
      <Notation />
      <AllParts />
      <Bass />
      <Bari />
      <Lead />
      <Tenor />
      <Other1 />
      <Other2 />
      <Other3 />
      <Other4 />
      <videos available="1" count="1">
         <video index="1">
            <id>1652</id>
            <Desc />
            <SungKey>Major:G</SungKey>
            <Multitrack>No</Multitrack>
            <Code />
            <Facebook>https://www.facebook.com/100004369746986/videos/1607779236044386/?extid=ymDkDyWmCH0gpXNa</Facebook>
            <SungBy>Nick Nack Paddy Catt</SungBy>
            <SungWebsite>http://https://www.facebook.com/NNPCQuartet</SungWebsite>
            <Posted>Mon, 28 Sep 2020</Posted>
         </video>
      </videos>
   </tag>
</tags>
''';
