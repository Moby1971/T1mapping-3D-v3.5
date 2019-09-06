function out2dseq = load2dseq(filename,imageinformation,reconstructioninformation)
% Written by:
%   Edwin Heijman   e.heijman@tue.nl July 2005
%
% Version: 1.0

if exist(filename,'file')
    % FID or image
    if str2num(imageinformation.im.siy)==1
        type='fid';
    else
        type='image';
    end;    
    
    % Retrieving image information
    im_n=length(reconstructioninformation.reco.transposition);
    byte_order=reconstructioninformation.reco.byte_order;
    word_type=reconstructioninformation.reco.wordtype;
    image_type=reconstructioninformation.reco.image_type;    
    
    % Create file handle to open file by open the file read-only, big endian
    switch byte_order
    case 'littleEndian'
        [fid,message] = fopen(filename,'r','l');
    case 'bigEndian'
        [fid,message] = fopen(filename,'r','b');
    otherwise
        disp('Unknown byte order (load2dseq)')
        %break
        return
    end;
    
    % Determine how the data is saved in which word type
    switch word_type
    case {'_32BIT_SGN_INT'}
        precision='int32';
    case {'_16BIT_SGN_INT'}
        precision='int16';
    case {'_8BIT_UNSGN_INT'}
        precision='uint8';
    case {'_32BIT_FLOAT'}
        precision='float32';
    otherwise
        disp('Unknown word type (load2dseq)')
        %break
        return
    end
    
    % Reading the data based on the file type    
    switch type
    case 'fid'
        switch image_type
        case 'COMPLEX_IMAGE'
            if fid~=-1
                im_six=str2num(imageinformation.im.six);
                F = fread(fid,[2*im_six],precision);
                out2dseq.fid=complex(F(1:im_six),F(1+im_six:2*im_six));
            else
                disp(message)
            end;
        case {'MAGNITUDE_IMAGE','REAL_IMAGE','IMAGINARY_IMAGE','PHASE_IMAGE','IR_IMAGE'}
            if fid~=-1
                im_six=str2num(imageinformation.im.six);
                F = fread(fid,[im_six],precision);
                out2dseq.fid=F;
            else
                disp(message)
            end;
        otherwise
            disp('Unknown fid type (load2dseq)')
            %break
            return
        end;
    case 'image'
        switch image_type
        case 'COMPLEX_IMAGE'
            if fid~=-1
                im_six=str2num(imageinformation.im.six);
                im_siy=str2num(imageinformation.im.siy);
                im_siz=str2num(imageinformation.im.siz)/2;
                im_sit=str2num(imageinformation.im.sit);
                F = fread(fid,[im_six,im_siy*2*im_siz*im_sit],precision);
                for j=1:im_sit
                    for i = 1:im_siz
                        out2dseq.images(:,:,i,j) = complex(flipud(rot90(F(1:im_six,2*(i-1)*j*im_siy+1       :im_siy+2*j*(i-1)*im_siy))),...
                            flipud(rot90(F(1:im_six,2*(i-1)*j*im_siy+1+im_siy:2*i*j*im_siy))));
                    end;
                end;
            else
                disp(message)
            end;
        case {'MAGNITUDE_IMAGE','REAL_IMAGE','IMAGINARY_IMAGE','PHASE_IMAGE','IR_IMAGE'}
            if fid~=-1
                im_six=str2num(imageinformation.im.six);
                im_siy=str2num(imageinformation.im.siy);
                im_siz=str2num(imageinformation.im.siz);
                im_sit=str2num(imageinformation.im.sit);
                F = fread(fid,[im_six,im_siy*im_siz*im_sit],precision);
                for j=1:im_sit
                    for i = 1:im_siz
                        out2dseq.images(:,:,i,j)=flipud(rot90(F(1:im_six,im_siy*(i-1)*j+1:im_siy*i*j)));
                    end;
                end;
            else
                disp(message)
            end;
        otherwise
            disp('Unknown image type (load2dseq)')
            %break
            return
        end;
    otherwise
        disp('Unknown type of data (load2dseq)')
        %break
        return
    end;
else 
    disp('Reconstruction file not found {load2dseq}')
    out2dseq=[];
end;