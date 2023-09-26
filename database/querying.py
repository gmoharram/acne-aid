from fastapi import HTTPException, status
from sqlmodel import select


async def insert_record(record, session) -> None:
    session.add(record)
    session.commit()
    session.refresh(record)


async def get_record(record_id, data_model, session):
    record = session.get(data_model, record_id)
    if record:
        return record
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Record with supplied ID doesn't exist",
        )


async def update_record(record_id, data_model, updated_record, session):
    record = get_record(record_id, data_model, session=session)
    record_data = updated_record.dict(exclude_unset=True)
    for key, value in record_data.items():
        setattr(record, key, value)
    session.add(record)
    session.commit()
    session.refresh(record)
    return record


async def delete_record(record_id, data_model, session):
    record = get_record(record_id, data_model, session=session)
    session.delete(record)
    session.commit()


async def select_all(data_model, session):
    records = session.exec(select(data_model)).all()
    return records
