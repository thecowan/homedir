#!/usr/bin/python
from mp3md import *

metadata_regex = r'(?i) ?[(\[]([^)\]]*((single|album) version|explicit|remaster|clean))[)\]]$'

runchecks([
  # check which fields should be stripped (e.g. J River tags)
  # Should I check TCON is consistent per folder?
  # "conducted by" banned in TPE1 (cf. BBC Philharmonic)
  # "strict" version - check full release date (yyyy-mm-dd)
  # Find chinese-looking characters?
  #FrameAbsentCheck(['COMM'], fix=StripFrame(['COMM'])),
  #FrameWhitelistCheck('TPE3', ['xxx']), # conductor
  #FrameWhitelistCheck('TCOM', ['xxx']), # composer

  TagVersionCheck(fix=UpdateTag()),
  FramePresentCheck(['TIT2', 'TPE1', 'APIC', 'TALB', 'TOWN', 'TRCK', 'TDRC']), # RVA2, TCON
  TrailingArtistCheck(),
  FramePresentCheck(['TPE2'], fix=ApplyCommonValue(source='TPE1', target='TPE2', outliers=1)),
  MutualPresenceCheck(['TOAL', 'TOPE', 'TDOR']),
  #TrackNumberContinuityCheck(),
  FrameBlacklistCheck('TCON', ['Alternative Rock'], regex=False, fix=ApplyValue('TCON', 'Alternative')),
  FrameWhitelistCheck('TOWN', ['allofmp3', 'cdbaby', 'purchasedonline', 'amazon', 'bleep', 'emusic', 'rip', 'hmm', 'nic', 'nate',
                               'free', 'chris', 'google', 'daytrotter', 'humblebundle', 'soundsupply', 'bandcamp']),
  FrameWhitelistCheck('TCON', ['Rock', 'Children\'s', 'Lullaby', 'Audiobook', 'Alternative', 'Poetry', 'Soundtrack', 'Indie',
                               'Christmas', 'Pop', 'Folk', 'Electronic', 'Folk', 'Comedy', 'Dance', 'Country', 'Classical',
                               'Bluegrass', 'Blues', 'World', 'Vocal', 'Swing', 'Punk', 'Hip-Hop', 'Musical', 'Latin', 'Jazz',
                               'Reggae', 'Mashup', 'R&B', 'Instrumental', 'Funk', 'Lounge', 'Soul', 'Chiptune']),
  #FrameBlacklistCheck('TIT2', [r'[\(\[].*with', r'[\(\[].*live', r'[\(\[].*remix', r'[\(\[].*cover'], regex=True),
  FrameBlacklistCheck('TALB', [r'(?i)dis[kc] [0-9]+'], regex=True),
  FrameBlacklistCheck('TALB', [r'\[\+digital booklet\]'], regex=True),
  #FrameBlacklistCheck('TPE1', [r'[Vv]arious', r' and ', r' with ', r' feat(uring|\.)? '], regex=True),
  FrameBlacklistCheck('TPE2', ['Various', 'Assorted'], regex=False, fix=ApplyValue('TPE2', 'Various Artists')),
  DependentValueCheck('TCMP', '1', 'TPE2', 'Various Artists', fix=ApplyValue('TCMP', '1')),
  FrameConsistencyCheck(['TALB', 'TPE2', 'TOWN', 'TDRL', 'TCMP']), # TCON?
  FrameAbsentCheck(['PRIV:contentgroup@emusic.com'], fix=StripFrame(['PRIV:contentgroup@emusic.com'])),
  FrameAbsentCheck(['PRIV:Google/UITS'], fix=StripFrame(['PRIV:Google/UITS'])),
  FrameAbsentCheck(['PRIV:Google/StoreId'], fix=StripFrame(['PRIV:Google/StoreId'])),
  FrameAbsentCheck(['COMM:Media Jukebox'], fix=StripFrame(['COMM:Media Jukebox'])),
  FrameAbsentCheck(['USER'], fix=StripFrame(['USER'])),
  FrameAbsentCheck(['PRIV:WM/UniqueFileIdentifier'], fix=StripFrame(['PRIV:WM/UniqueFileIdentifier'])),
  FrameAbsentCheck(['PRIV:WM/MediaClassSecondaryID'], fix=StripFrame(['PRIV:WM/MediaClassSecondaryID'])),
  FrameAbsentCheck(['PRIV:WM/WMCollectionGroupID'], fix=StripFrame(['PRIV:WM/WMCollectionGroupID'])),
  FrameAbsentCheck(['PRIV:WM/Provider'], fix=StripFrame(['PRIV:WM/Provider'])),
  FrameAbsentCheck(['PRIV:WM/MediaClassPrimaryID'], fix=StripFrame(['PRIV:WM/MediaClassPrimaryID'])),
  FrameAbsentCheck(['PRIV:WM/WMContentID'], fix=StripFrame(['PRIV:WM/WMContentID'])),
  FrameAbsentCheck(['PRIV:WM/WMCollectionID'], fix=StripFrame(['PRIV:WM/WMCollectionID'])),
  FrameAbsentCheck(['PRIV:PeakValue'], fix=StripFrame(['PRIV:PeakValue'])),
  FrameAbsentCheck(['PRIV:AverageLevel'], fix=StripFrame(['PRIV:AverageLevel'])),
  FrameAbsentCheck(['PRIV:Google/UITS'], fix=StripFrame(['PRIV:Google/UITS'])),
  FrameAbsentCheck(['PRIV:Google/StoreId'], fix=StripFrame(['PRIV:Google/StoreId'])),
  FrameAbsentCheck(['PRIV:www.amazon.com'], fix=StripFrame(['PRIV:www.amazon.com'])),
  FrameBlacklistCheck('TIT2', [metadata_regex], regex=True, fix=MigrateRegex(regex=metadata_regex, from_frame='TIT2', to_frame='TIT3', overwrite=False, match_group=1)),
  # FrameAbsentCheck(['PRIV'], fix=StripFrame(['PRIV'])),
  Compressed24Tag(fix=UpdateTag()),
])
