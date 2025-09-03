#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
API 문서 업데이트 스크립트
실제 API 응답과 xlsx 문서를 비교하여 불일치하는 부분을 수정합니다.
"""

import pandas as pd
import json
from datetime import datetime
import os

def update_companies_api_doc():
    """회사정보_조회.xlsx 문서를 업데이트합니다."""
    
    # xlsx 파일 읽기
    file_path = 'API_Files/05_회사정보_조회.xlsx'
    df = pd.read_excel(file_path)
    
    print("=== 기존 문서 내용 ===")
    print(df.to_string())
    print("\n" + "="*50)
    
    # 새로운 응답 형식에 맞게 데이터 수정
    new_data = []
    
    # 기존 행들을 유지하면서 필요한 부분만 수정
    for idx, row in df.iterrows():
        if pd.isna(row['항목']):
            new_data.append(row)
            continue
            
        if row['항목'] == 'pagination':
            # pagination을 filters로 변경
            new_row = row.copy()
            new_row['항목'] = 'filters'
            new_row['내용'] = '필터 정보'
            new_row['Unnamed: 2'] = 'OBJECT'
            new_row['Unnamed: 3'] = '필터 정보'
            new_row['Unnamed: 4'] = '날짜, 페이지 정보'
            new_data.append(new_row)
            
            # totalCount 필드 추가
            total_count_row = pd.Series({
                '항목': 'totalCount',
                '내용': '전체 건수',
                'Unnamed: 2': 'INTEGER',
                'Unnamed: 3': '필터 조건에 맞는 전체 회사 수',
                'Unnamed: 4': 'Y'
            })
            new_data.append(total_count_row)
            
        elif row['항목'] == '입력 파라미터':
            new_data.append(row)
            # startDate, endDate 파라미터 추가
            start_date_row = pd.Series({
                '항목': 'startDate',
                '내용': 'STRING',
                'Unnamed: 2': '검색 시작일',
                'Unnamed: 3': 'N',
                'Unnamed: 4': 'YYYY-MM-DD 형식'
            })
            new_data.append(start_date_row)
            
            end_date_row = pd.Series({
                '항목': 'endDate',
                '내용': 'STRING',
                'Unnamed: 2': '검색 종료일',
                'Unnamed: 3': 'N',
                'Unnamed: 4': 'YYYY-MM-DD 형식'
            })
            new_data.append(end_date_row)
            
        elif row['항목'] == '출력 파라미터':
            new_data.append(row)
            # filters 상세 정보 추가
            filters_detail_rows = [
                pd.Series({
                    '항목': 'filters.startDate',
                    '내용': 'STRING',
                    'Unnamed: 2': '검색 시작일',
                    'Unnamed: 3': 'Y',
                    'Unnamed: 4': 'ISO 8601 형식'
                }),
                pd.Series({
                    '항목': 'filters.endDate',
                    '내용': 'STRING',
                    'Unnamed: 2': '검색 종료일',
                    'Unnamed: 3': 'Y',
                    'Unnamed: 4': 'ISO 8601 형식'
                }),
                pd.Series({
                    '항목': 'filters.page',
                    '내용': 'INTEGER',
                    'Unnamed: 2': '현재 페이지 번호',
                    'Unnamed: 3': 'Y',
                    'Unnamed: 4': '페이지 정보'
                }),
                pd.Series({
                    '항목': 'filters.limit',
                    '내용': 'INTEGER',
                    'Unnamed: 2': '페이지당 항목 수',
                    'Unnamed: 3': 'Y',
                    'Unnamed: 4': '페이지 정보'
                })
            ]
            new_data.extend(filters_detail_rows)
            
        else:
            new_data.append(row)
    
    # 새로운 DataFrame 생성
    new_df = pd.DataFrame(new_data)
    
    print("=== 업데이트된 문서 내용 ===")
    print(new_df.to_string())
    
    # 백업 파일 생성
    backup_path = f"API_Files/05_회사정보_조회_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}.xlsx"
    df.to_excel(backup_path, index=False)
    print(f"\n백업 파일 생성: {backup_path}")
    
    # 새로운 파일로 저장
    new_df.to_excel(file_path, index=False)
    print(f"문서 업데이트 완료: {file_path}")
    
    return new_df

def update_relationship_api_docs():
    """관계정보/매핑정보 API 문서들을 업데이트합니다."""
    
    # 업데이트할 관계정보 API 문서 목록
    relationship_apis = [
        {
            'file': '10_병원업체_관계정보.xlsx',
            'api_path': '/api/hospital-company-mappings',
            'description': '병원업체 관계정보'
        },
        {
            'file': '11_병원약국_관계정보.xlsx',
            'api_path': '/api/hospital-pharmacy-mappings',
            'description': '병원약국 관계정보'
        },
        {
            'file': '12_병원업체_매핑정보.xlsx',
            'api_path': '/api/client-company-assignments',
            'description': '병원업체 매핑정보'
        },
        {
            'file': '13_병원약국_매핑정보.xlsx',
            'api_path': '/api/client-pharmacy-assignments',
            'description': '병원약국 매핑정보'
        },
        {
            'file': '14_제품업체_미배정매핑.xlsx',
            'api_path': '/api/product-company-not-assignments',
            'description': '제품업체 미배정매핑'
        }
    ]
    
    for api_doc in relationship_apis:
        file_path = f"API_Files/{api_doc['file']}"
        if os.path.exists(file_path):
            print(f"\n=== {api_doc['description']} 문서 업데이트 ===")
            try:
                update_relationship_api_doc(file_path, api_doc)
            except Exception as e:
                print(f"오류 발생: {e}")

def update_relationship_api_doc(file_path, api_info):
    """관계정보 API 문서를 업데이트합니다."""
    
    # xlsx 파일 읽기
    df = pd.read_excel(file_path)
    
    # 백업 파일 생성
    backup_path = f"{file_path.replace('.xlsx', '')}_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}.xlsx"
    df.to_excel(backup_path, index=False)
    print(f"백업 파일 생성: {backup_path}")
    
    # pagination을 filters로 변경하고 totalCount 추가
    new_data = []
    for idx, row in df.iterrows():
        if pd.isna(row['항목']):
            new_data.append(row)
            continue
            
        if row['항목'] == 'pagination':
            # pagination을 filters로 변경
            new_row = row.copy()
            new_row['항목'] = 'filters'
            new_row['내용'] = '필터 정보'
            new_row['Unnamed: 2'] = 'OBJECT'
            new_row['Unnamed: 3'] = '필터 정보'
            new_row['Unnamed: 4'] = '날짜, 페이지 정보'
            new_data.append(new_row)
            
            # totalCount 필드 추가
            total_count_row = pd.Series({
                '항목': 'totalCount',
                '내용': '전체 건수',
                'Unnamed: 2': 'INTEGER',
                'Unnamed: 3': '필터 조건에 맞는 전체 건수',
                'Unnamed: 4': 'Y'
            })
            new_data.append(total_count_row)
            
        elif row['항목'] == '입력 파라미터':
            new_data.append(row)
            # startDate, endDate 파라미터 추가
            start_date_row = pd.Series({
                '항목': 'startDate',
                '내용': 'STRING',
                'Unnamed: 2': '검색 시작일',
                'Unnamed: 3': 'N',
                'Unnamed: 4': 'YYYY-MM-DD 형식'
            })
            new_data.append(start_date_row)
            
            end_date_row = pd.Series({
                '항목': 'endDate',
                '내용': 'STRING',
                'Unnamed: 2': '검색 종료일',
                'Unnamed: 3': 'N',
                'Unnamed: 4': 'YYYY-MM-DD 형식'
            })
            new_data.append(end_date_row)
            
        else:
            new_data.append(row)
    
    # 새로운 DataFrame 생성
    new_df = pd.DataFrame(new_data)
    
    # 새로운 파일로 저장
    new_df.to_excel(file_path, index=False)
    print(f"문서 업데이트 완료: {file_path}")

def update_sales_api_docs():
    """매출 관련 API 문서들을 업데이트합니다."""
    
    # 업데이트할 매출 API 문서 목록
    sales_apis = [
        {
            'file': '15_도매매출_조회.xlsx',
            'api_path': '/api/wholesale-sales',
            'description': '도매매출 조회'
        },
        {
            'file': '16_직매매출_조회.xlsx',
            'api_path': '/api/direct-sales',
            'description': '직매매출 조회'
        }
    ]
    
    for api_doc in sales_apis:
        file_path = f"API_Files/{api_doc['file']}"
        if os.path.exists(file_path):
            print(f"\n=== {api_doc['description']} 문서 업데이트 ===")
            try:
                update_sales_api_doc(file_path, api_doc)
            except Exception as e:
                print(f"오류 발생: {e}")

def update_sales_api_doc(file_path, api_info):
    """매출 API 문서를 업데이트합니다."""
    
    # xlsx 파일 읽기
    df = pd.read_excel(file_path)
    
    # 백업 파일 생성
    backup_path = f"{file_path.replace('.xlsx', '')}_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}.xlsx"
    df.to_excel(backup_path, index=False)
    print(f"백업 파일 생성: {backup_path}")
    
    # pagination을 filters로 변경하고 totalCount 추가
    new_data = []
    for idx, row in df.iterrows():
        if pd.isna(row['항목']):
            new_data.append(row)
            continue
            
        if row['항목'] == 'pagination':
            # pagination을 filters로 변경
            new_row = row.copy()
            new_row['항목'] = 'filters'
            new_row['내용'] = '필터 정보'
            new_row['Unnamed: 2'] = 'OBJECT'
            new_row['Unnamed: 3'] = '필터 정보'
            new_row['Unnamed: 4'] = '날짜, 페이지 정보'
            new_data.append(new_row)
            
            # totalCount 필드 추가
            total_count_row = pd.Series({
                '항목': 'totalCount',
                '내용': '전체 건수',
                'Unnamed: 2': 'INTEGER',
                'Unnamed: 3': '필터 조건에 맞는 전체 건수',
                'Unnamed: 4': 'Y'
            })
            new_data.append(total_count_row)
            
        elif row['항목'] == '입력 파라미터':
            new_data.append(row)
            # startDate, endDate 파라미터 추가
            start_date_row = pd.Series({
                '항목': 'startDate',
                '내용': 'STRING',
                'Unnamed: 2': '검색 시작일',
                'Unnamed: 3': 'N',
                'Unnamed: 4': 'YYYY-MM-DD 형식'
            })
            new_data.append(start_date_row)
            
            end_date_row = pd.Series({
                '항목': 'endDate',
                '내용': 'STRING',
                'Unnamed: 2': '검색 종료일',
                'Unnamed: 3': 'N',
                'Unnamed: 4': 'YYYY-MM-DD 형식'
            })
            new_data.append(end_date_row)
            
        else:
            new_data.append(row)
    
    # 새로운 DataFrame 생성
    new_df = pd.DataFrame(new_data)
    
    # 새로운 파일로 저장
    new_df.to_excel(file_path, index=False)
    print(f"문서 업데이트 완료: {file_path}")

def update_performance_api_docs():
    """실적 관련 API 문서들을 업데이트합니다."""
    
    # 업데이트할 실적 API 문서 목록
    performance_apis = [
        {
            'file': '17_실적정보_목록조회.xlsx',
            'api_path': '/api/performance-records',
            'description': '실적정보 목록조회'
        },
        {
            'file': '18_실적흡수율_정보.xlsx',
            'api_path': '/api/performance-records-absorption',
            'description': '실적흡수율 정보'
        },
        {
            'file': '19_실적증빙파일.xlsx',
            'api_path': '/api/performance-evidence-files',
            'description': '실적증빙파일'
        }
    ]
    
    for api_doc in performance_apis:
        file_path = f"API_Files/{api_doc['file']}"
        if os.path.exists(file_path):
            print(f"\n=== {api_doc['description']} 문서 업데이트 ===")
            try:
                update_performance_api_doc(file_path, api_doc)
            except Exception as e:
                print(f"오류 발생: {e}")

def update_performance_api_doc(file_path, api_info):
    """실적 API 문서를 업데이트합니다."""
    
    # xlsx 파일 읽기
    df = pd.read_excel(file_path)
    
    # 백업 파일 생성
    backup_path = f"{file_path.replace('.xlsx', '')}_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}.xlsx"
    df.to_excel(backup_path, index=False)
    print(f"백업 파일 생성: {backup_path}")
    
    # pagination을 filters로 변경하고 totalCount 추가
    new_data = []
    for idx, row in df.iterrows():
        if pd.isna(row['항목']):
            new_data.append(row)
            continue
            
        if row['항목'] == 'pagination':
            # pagination을 filters로 변경
            new_row = row.copy()
            new_row['항목'] = 'filters'
            new_row['내용'] = '필터 정보'
            new_row['Unnamed: 2'] = 'OBJECT'
            new_row['Unnamed: 3'] = '필터 정보'
            new_row['Unnamed: 4'] = '날짜, 페이지 정보'
            new_data.append(new_row)
            
            # totalCount 필드 추가
            total_count_row = pd.Series({
                '항목': 'totalCount',
                '내용': '전체 건수',
                'Unnamed: 2': 'INTEGER',
                'Unnamed: 3': '필터 조건에 맞는 전체 건수',
                'Unnamed: 4': 'Y'
            })
            new_data.append(total_count_row)
            
        elif row['항목'] == '입력 파라미터':
            new_data.append(row)
            # startDate, endDate 파라미터 추가
            start_date_row = pd.Series({
                '항목': 'startDate',
                '내용': 'STRING',
                'Unnamed: 2': '검색 시작일',
                'Unnamed: 3': 'N',
                'Unnamed: 4': 'YYYY-MM-DD 형식'
            })
            new_data.append(start_date_row)
            
            end_date_row = pd.Series({
                '항목': 'endDate',
                '내용': 'STRING',
                'Unnamed: 2': '검색 종료일',
                'Unnamed: 3': 'N',
                'Unnamed: 4': 'YYYY-MM-DD 형식'
            })
            new_data.append(end_date_row)
            
        else:
            new_data.append(row)
    
    # 새로운 DataFrame 생성
    new_df = pd.DataFrame(new_data)
    
    # 새로운 파일로 저장
    new_df.to_excel(file_path, index=False)
    print(f"문서 업데이트 완료: {file_path}")

def update_settlement_api_docs():
    """정산 관련 API 문서들을 업데이트합니다."""
    
    # 업데이트할 정산 API 문서 목록
    settlement_apis = [
        {
            'file': '20_정산월_목록조회.xlsx',
            'api_path': '/api/settlement-months',
            'description': '정산월 목록조회'
        },
        {
            'file': '21_정산내역서_목록조회.xlsx',
            'api_path': '/api/settlement-share',
            'description': '정산내역서 목록조회'
        }
    ]
    
    for api_doc in settlement_apis:
        file_path = f"API_Files/{api_doc['file']}"
        if os.path.exists(file_path):
            print(f"\n=== {api_doc['description']} 문서 업데이트 ===")
            try:
                update_settlement_api_doc(file_path, api_doc)
            except Exception as e:
                print(f"오류 발생: {e}")

def update_settlement_api_doc(file_path, api_info):
    """정산 API 문서를 업데이트합니다."""
    
    # xlsx 파일 읽기
    df = pd.read_excel(file_path)
    
    # 백업 파일 생성
    backup_path = f"{file_path.replace('.xlsx', '')}_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}.xlsx"
    df.to_excel(backup_path, index=False)
    print(f"백업 파일 생성: {backup_path}")
    
    # pagination을 filters로 변경하고 totalCount 추가
    new_data = []
    for idx, row in df.iterrows():
        if pd.isna(row['항목']):
            new_data.append(row)
            continue
            
        if row['항목'] == 'pagination':
            # pagination을 filters로 변경
            new_row = row.copy()
            new_row['항목'] = 'filters'
            new_row['내용'] = '필터 정보'
            new_row['Unnamed: 2'] = 'OBJECT'
            new_row['Unnamed: 3'] = '필터 정보'
            new_row['Unnamed: 4'] = '날짜, 페이지 정보'
            new_row['Unnamed: 4'] = '날짜, 페이지 정보'
            new_data.append(new_row)
            
            # totalCount 필드 추가
            total_count_row = pd.Series({
                '항목': 'totalCount',
                '내용': '전체 건수',
                'Unnamed: 2': 'INTEGER',
                'Unnamed: 3': '필터 조건에 맞는 전체 건수',
                'Unnamed: 4': 'Y'
            })
            new_data.append(total_count_row)
            
        elif row['항목'] == '입력 파라미터':
            new_data.append(row)
            # startDate, endDate 파라미터 추가
            start_date_row = pd.Series({
                '항목': 'startDate',
                '내용': 'STRING',
                'Unnamed: 2': '검색 시작일',
                'Unnamed: 3': 'N',
                'Unnamed: 4': 'YYYY-MM-DD 형식'
            })
            new_data.append(start_date_row)
            
            end_date_row = pd.Series({
                '항목': 'endDate',
                '내용': 'STRING',
                'Unnamed: 2': '검색 종료일',
                'Unnamed: 3': 'N',
                'Unnamed: 4': 'YYYY-MM-DD 형식'
            })
            new_data.append(end_date_row)
            
        else:
            new_data.append(row)
    
    # 새로운 DataFrame 생성
    new_df = pd.DataFrame(new_data)
    
    # 새로운 파일로 저장
    new_df.to_excel(file_path, index=False)
    print(f"문서 업데이트 완료: {file_path}")

def update_other_api_docs():
    """다른 API 문서들도 업데이트합니다."""
    
    # 업데이트할 API 문서 목록
    api_docs = [
        {
            'file': '06_제품정보_조회.xlsx',
            'api_path': '/api/products',
            'description': '제품정보 조회'
        },
        {
            'file': '07_병원정보_조회.xlsx',
            'api_path': '/api/clients',
            'description': '병원정보 조회'
        },
        {
            'file': '08_약국정보_조회.xlsx',
            'api_path': '/api/pharmacies',
            'description': '약국정보 조회'
        },
        {
            'file': '09_공지사항_조회.xlsx',
            'api_path': '/api/notices',
            'description': '공지사항 조회'
        }
    ]
    
    for api_doc in api_docs:
        file_path = f"API_Files/{api_doc['file']}"
        if os.path.exists(file_path):
            print(f"\n=== {api_doc['description']} 문서 업데이트 ===")
            try:
                update_generic_api_doc(file_path, api_doc)
            except Exception as e:
                print(f"오류 발생: {e}")

def update_generic_api_doc(file_path, api_info):
    """일반적인 API 문서를 업데이트합니다."""
    
    # xlsx 파일 읽기
    df = pd.read_excel(file_path)
    
    # 백업 파일 생성
    backup_path = f"{file_path.replace('.xlsx', '')}_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}.xlsx"
    df.to_excel(backup_path, index=False)
    print(f"백업 파일 생성: {backup_path}")
    
    # pagination을 filters로 변경하고 totalCount 추가
    new_data = []
    for idx, row in df.iterrows():
        if pd.isna(row['항목']):
            new_data.append(row)
            continue
            
        if row['항목'] == 'pagination':
            # pagination을 filters로 변경
            new_row = row.copy()
            new_row['항목'] = 'filters'
            new_row['내용'] = '필터 정보'
            new_row['Unnamed: 2'] = 'OBJECT'
            new_row['Unnamed: 3'] = '필터 정보'
            new_row['Unnamed: 4'] = '날짜, 페이지 정보'
            new_row['Unnamed: 4'] = '날짜, 페이지 정보'
            new_data.append(new_row)
            
            # totalCount 필드 추가
            total_count_row = pd.Series({
                '항목': 'totalCount',
                '내용': '전체 건수',
                'Unnamed: 2': 'INTEGER',
                'Unnamed: 3': '필터 조건에 맞는 전체 건수',
                'Unnamed: 4': 'Y'
            })
            new_data.append(total_count_row)
            
        elif row['항목'] == '입력 파라미터':
            new_data.append(row)
            # startDate, endDate 파라미터 추가
            start_date_row = pd.Series({
                '항목': 'startDate',
                '내용': 'STRING',
                'Unnamed: 2': '검색 시작일',
                'Unnamed: 3': 'N',
                'Unnamed: 4': 'YYYY-MM-DD 형식'
            })
            new_data.append(start_date_row)
            
            end_date_row = pd.Series({
                '항목': 'endDate',
                '내용': 'STRING',
                'Unnamed: 2': '검색 종료일',
                'Unnamed: 3': 'N',
                'Unnamed: 4': 'YYYY-MM-DD 형식'
            })
            new_data.append(end_date_row)
            
        else:
            new_data.append(row)
    
    # 새로운 DataFrame 생성
    new_df = pd.DataFrame(new_data)
    
    # 새로운 파일로 저장
    new_df.to_excel(file_path, index=False)
    print(f"문서 업데이트 완료: {file_path}")

if __name__ == "__main__":
    print("🚀 API 문서 업데이트 시작")
    print("="*50)
    
    # 회사정보 API 문서 업데이트
    update_companies_api_doc()
    
    # 관계정보/매핑정보 API 문서들 업데이트
    update_relationship_api_docs()
    
    # 매출 관련 API 문서들 업데이트
    update_sales_api_docs()
    
    # 실적 관련 API 문서들 업데이트
    update_performance_api_docs()
    
    # 정산 관련 API 문서들 업데이트
    update_settlement_api_docs()
    
    # 다른 API 문서들 업데이트
    update_other_api_docs()
    
    print("\n🎉 모든 API 문서 업데이트 완료!")
    print("="*50)
