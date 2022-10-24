/////////////////////////////////////////////////////////////////////////////////////////////////
//
//  Tencent is pleased to support the open source community by making TAVMedia available.
//
//  Copyright (C) 2022 THL A29 Limited, a Tencent company. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  unless required by applicable law or agreed to in writing, software distributed under the
//  license is distributed on an "as is" basis, without warranties or conditions of any kind,
//  either express or implied. see the license for the specific language governing permissions
//  and limitations under the license.
//
/////////////////////////////////////////////////////////////////////////////////////////////////

typedef enum {
    OK = 0,

    ERROR_CANCEL = -1,
    ERROR_LAST_MOVIE_GENERATE_NOT_FINISH = -2,
    ERROR_MUXER_CREATE = -3,
    ERROR_MUXER_START = -4,
    ERROR_MUXER_STOP = -5,

    ERROR_START_AUDIO_ENCODER = -101,
    ERROR_START_VIDEO_ENCODER = -102,
    ERROR_AUDIO_CONFIGURE = -103,
    ERROR_VIDEO_CONFIGURE = -104,

    ERROR_READ_AUDIO_FRAME = -201,
    ERROR_READ_VIDEO_FRAME = -202,

    ERROR_ENCODE_AUDIO_FRAME = -301,
    ERROR_ENCODE_VIDEO_FRAME = -302,

    ERROR_WRITE_AUDIO_FRAME = -401,
    ERROR_WRITE_VIDEO_FRAME = -402,

    ERROR_END_WRITE_AUDIO_FRAME = -501,
    ERROR_END_WRITE_VIDEO_FRAME = -502,

    ERROR_CONCAT_FILE = -601,
    ERROR_DELETE_CONCAT_TEMP_FILE = -602,

    ERROR_EXPORT_PATH = -701,
    ERROR_EXPORT_CONFIGURE = -702,
} TAVExportErrorCode;
