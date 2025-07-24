const fs = require('fs');
const path = require('path');

// 이미지 폴더 경로
const imageDir = './vue-project/public/manual-images';
const outputDir = './public/docs';

// 이미지 파일들을 Base64로 변환하는 함수
function convertImageToBase64(imagePath) {
    try {
        const imageBuffer = fs.readFileSync(imagePath);
        const base64String = imageBuffer.toString('base64');
        const fileName = path.basename(imagePath, path.extname(imagePath));
        const fileExt = path.extname(imagePath).substring(1);
        
        return {
            fileName: fileName,
            mimeType: `image/${fileExt}`,
            base64: base64String,
            dataUrl: `data:image/${fileExt};base64,${base64String}`
        };
    } catch (error) {
        console.error(`Error converting ${imagePath}:`, error.message);
        return null;
    }
}

// 모든 PNG 이미지 파일을 변환
function convertAllImages() {
    try {
        const files = fs.readdirSync(imageDir);
        const pngFiles = files.filter(file => file.endsWith('.png'));
        
        console.log(`Found ${pngFiles.length} PNG files to convert...`);
        
        const convertedImages = {};
        
        pngFiles.forEach(file => {
            const imagePath = path.join(imageDir, file);
            const result = convertImageToBase64(imagePath);
            
            if (result) {
                convertedImages[result.fileName] = result;
                console.log(`✓ Converted: ${file}`);
            }
        });
        
        // 결과를 JSON 파일로 저장
        const outputPath = path.join(outputDir, 'converted_images.json');
        fs.writeFileSync(outputPath, JSON.stringify(convertedImages, null, 2));
        
        console.log(`\nConversion completed! Results saved to: ${outputPath}`);
        console.log(`Total images converted: ${Object.keys(convertedImages).length}`);
        
        return convertedImages;
    } catch (error) {
        console.error('Error reading directory:', error.message);
        return {};
    }
}

// 스크립트 실행
if (require.main === module) {
    convertAllImages();
}

module.exports = { convertImageToBase64, convertAllImages }; 